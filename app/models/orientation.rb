class Orientation < ApplicationRecord
  include Searchable
  include OrientationStatus
  include OrientationFilter
  include OrientationJoin
  include OrientationOption
  include OrientationDocuments
  include OrientationTcoTcai
  include OrientationReport
  include OrientationValidation
  include AcademicDocuments
  include AcademicDocumentsInfo
  include UsersToDocument

  searchable :status, title: { unaccent: true }, relationships: {
    calendars: { fields: [:year] },
    academic: { fields: [name: { unaccent: true }, ra: { unaccent: false }] },
    institution: { fields: [name: { unaccent: true }, trade_name: { unaccent: true }] },
    advisor: { table_name: 'professors', fields: [name: { unaccent: true }] }
  }

  belongs_to :academic
  belongs_to :advisor, class_name: 'Professor', inverse_of: :orientations
  belongs_to :institution, optional: true

  has_many :orientation_calendars, dependent: :destroy
  has_many :calendars, through: :orientation_calendars

  has_many :orientation_supervisors, dependent: :delete_all
  has_many :signatures, dependent: :destroy
  has_many :documents, -> { select('DISTINCT ON (documents.id) documents.*') }, through: :signatures
  has_many :meetings, dependent: :destroy
  has_many :examination_boards, dependent: :destroy
  has_many :academic_activities, through: :academic, source: :academic_activities
  has_many :professor_supervisors, class_name: 'Professor', foreign_key: :professor_supervisor_id,
                                   through: :orientation_supervisors, dependent: :destroy

  has_many :external_member_supervisors, class_name: 'ExternalMember',
                                         foreign_key: :external_member_supervisor_id,
                                         through: :orientation_supervisors,
                                         dependent: :destroy

  validates :title, presence: true
  validate :validates_supervisor_ids
  validates :calendars, presence: true

  scope :tcc_one, lambda { |status, year = nil, semester = nil|
    join_with_status_by_tcc('one', status, year, semester)
  }

  scope :tcc_two, lambda { |status, year = nil, semester = nil|
    join_with_status_by_tcc('two', status, year, semester)
  }

  scope :current_tcc_one, lambda { |status = nil|
    join_with_status(join_current_calendar_tcc_one, status)
  }

  scope :current_tcc_two, lambda { |status = nil|
    join_with_status(join_current_calendar_tcc_two, status)
  }

  scope :with_relationships, lambda {
    includes(:academic, :calendars, :orientation_calendars, :documents, :meetings,
             :professor_supervisors, :orientation_supervisors,
             :external_member_supervisors, advisor: [:scholarity])
  }

  scope :recent, -> { order('calendars.year DESC, calendars.semester ASC, title, academics.name') }
  scope :order_by_academic, -> { order('academics.name') }

  def short_title
    title.length > 35 ? "#{title[0..35]}..." : title
  end

  def supervisors
    professor_supervisors + external_member_supervisors
  end

  def renew(justification)
    next_calendar = Calendar.next_semester(calendars.last)
    return false if next_calendar.blank?

    calendars << next_calendar
    update(renewal_justification: justification, status: 'RENEWED')
  end

  def cancel(justification)
    update(cancellation_justification: justification, status: 'CANCELED')
  end

  def active?
    !canceled? && !abandoned?
  end

  def current_calendar
    calendars.last
  end

  # TODO: Refactored and Remove
  def calendar_tcc_one?
    current_calendar.tcc == 'one'
  end

  # TODO: Refactore and Remove
  def calendar_tcc_two?
    current_calendar.tcc == 'two'
  end

  def tcc_one?
    current_calendar.tcc.eql?('one')
  end

  def tcc_two?
    current_calendar.tcc.eql?('two')
  end

  def professor_supervisors_to_document
    users_to_document(professor_supervisors)
  end

  def external_member_supervisors_to_document
    users_to_document(external_member_supervisors)
  end

  def academic_with_calendar
    "#{academic.name} (#{academic.ra}) | #{current_calendar.year_with_semester_and_tcc}"
  end

  def self.to_json_table(orientations)
    orientations.to_json(methods: [:short_title, :final_proposal, :final_project, :final_monograph,
                                   :document_title, :document_summary],
                         include: [:academic, { supervisors: { methods: [:name_with_scholarity] } },
                                   { advisor: { methods: [:name_with_scholarity] } }])
  end

  def self.select_status_data
    statuses.map { |index, field| [field, index.capitalize] }.sort!
  end
end
