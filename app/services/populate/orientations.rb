class Populate::Orientations
  attr_reader :academic_ids, :institution_ids,
              :calendar_ids, :advisor, :professors,
              :index, :external_members

  def initialize
    @academic_ids = Academic.pluck(:id)
    @institution_ids = Institution.pluck(:id)
    @advisor = Professor.find_by(username: 'marczal')
    @professors = Professor.where.not(username: 'marczal')
    @external_members = ExternalMember.all
    @calendar_ids = Calendar.pluck(:id)
    @index = 0
  end

  def populate
    @calendar_ids.each do |calendar_id|
      10.times do
        create_orientation_by_calendar(calendar_id)
      end
    end
  end

  private

  def create_orientation_by_calendar(calendar_id)
    increment_index
    orientation = Orientation.create(
      title: "Orientation #{@index}",
      calendar_id: calendar_id,
      advisor_id: @advisor.id,
      academic_id: @academic_ids.sample,
      institution_id: @institution_ids.sample
    )
    add_supervisors(orientation)
  end

  def increment_index
    @index += 1
  end

  def add_supervisors(orientation)
    orientation.professor_supervisors << @professors.sample
    orientation.external_member_supervisors << @external_members.sample
    orientation.save
  end
end
