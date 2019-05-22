class Populate::Orientations
  attr_reader :professor_ids, :academic_ids, :institution_ids

  def initialize
    @academic_ids = Academic.pluck(:id)
    @professor_ids = Professor.pluck(:id)
    @institution_ids = Institution.pluck(:id)
  end

  def populate(
    calendar_ids = Calendar.pluck(:id),
    current_tcc_one_id = Calendar.current_by_tcc_one.id,
    current_tcc_two_id = Calendar.current_by_tcc_two.id
  )
    50.times do
      create_orientation_by_calendar(current_tcc_one_id)
      create_orientation_by_calendar(current_tcc_two_id)
      create_orientation_by_calendar(calendar_ids.sample)
    end
  end

  private

  def create_orientation_by_calendar(calendar_id)
    Orientation.create(
      title: Faker::Lorem.sentence(3),
      calendar_id: calendar_id,
      advisor_id: @professor_ids.sample,
      academic_id: @academic_ids.sample,
      institution_id: @institution_ids.sample
    )
  end
end