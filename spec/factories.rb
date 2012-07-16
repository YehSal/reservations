FactoryGirl.define do

  r = Random.new
#  def time_rand(from = 0.0, to = Time.now)
#    Time.at(from + rand * (to.to_f - from.to_f))
#  end
#  random_time = time_rand(Time.local(2010, 1, 1))
#  random_due_date = time_rand(random_time, Time.now.next_week)


  factory :user do
    sequence(:login) {|n| "netid#{n}" }
    sequence(:first_name) {|n| "First#{n}"}
    sequence(:last_name) {|n| "Last#{n}"}
    phone "1234567890"
    email {"#{first_name}.#{last_name}@yale.edu"}
    affiliation "YC"
    adminmode false

    factory :admin do
      sequence(:first_name) {|n| "Admin#{n}"}
      adminmode true
    end
  end

  factory :category do
    sequence(:name) {|n| "Category#{n}"}
    max_per_user r.rand(1..40)
    max_checkout_length r.rand(5..40)
    sort_order r.rand(100)
    max_renewal_times r.rand(0..40)
    max_renewal_length r.rand(0..40)
    renewal_days_before_due r.rand(0..9001)
  end

  factory :equipment_model do
    sequence(:name) {|n| "EquipmentModel#{n}"}
    description Faker::HipsterIpsum.paragraph(4)
    late_fee r.rand(50.00..1000.00).round(2).to_d
    replacement_fee r.rand(50.00..1000.00).round(2).to_d
    max_per_user r.rand(1..40)
    active true
    max_renewal_times r.rand(0..40)
    max_renewal_length r.rand(0..40)
    renewal_days_before_due r.rand(0..9001)
    category
  end

  factory :equipment_object do
    sequence(:name) {|n| "EquipmentObject#{n}"}
    serial r.rand(10000000...99999999)
    active true
    equipment_model
  end

  factory :reservation do
    start_date Date.today
    due_date Date.tomorrow
    association :reserver, :factory => :user
    equipment_model
    after_build { |res| res.equipment_model_id = res.equipment_model.id }
    after_build do |res|
      obj = FactoryGirl.create(:equipment_object, :equipment_model => res.equipment_model)
      res.equipment_object = obj
    end

    factory :finalized_reservation do
    end

    factory :checked_out_reservation do
      checked_out Date.today
     #association :checkout_handler, factory => :user
    end

    factory :checked_in_reservation do
      start_date Date.yesterday
      due_date Date.today
      checked_out Date.yesterday
      checked_in Date.today
      #association :checkout_handler, factory => :user
      #association :checkin_handler, factory => :user
    end
  end
end
