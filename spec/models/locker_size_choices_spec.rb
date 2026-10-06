# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LockerSizeChoices do
  it 'allows juniors to apply for 4-foot and 6-foot lockers' do
    user = instance_double(User, junior?: true, sophomore?: false, first_year?: false)
    expect(described_class.new.call(building_name: 'Firestone Library', user:)).to eq([4, 6])
  end
end
