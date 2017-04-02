require 'rails_helper'

RSpec.describe Person, type: :model do
  subject { Person.new }

  it "is valid with valid attributes" do
    subject.first_name = "juan"
    subject.first_name = "perez"
    subject.is_professor = false
    expect(subject).to be_valid
  end
end
