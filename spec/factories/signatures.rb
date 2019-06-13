FactoryBot.define do
  factory :signature do
    orientation
    document
    user_id { Faker::Number.non_zero_digit }
    user_type { 'P' }
    status { false }
  end
end