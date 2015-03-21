require 'spec_helper'

describe Review do
  it { should belong_to(:video) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:rating) }
  it { should validate_numericality_of(:rating).
       only_integer.
       is_less_than_or_equal_to(5).
       is_greater_than_or_equal_to(1) }
end
