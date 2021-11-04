# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'lockers/new', type: :view do
  before(:each) do
    assign(:locker, Locker.new(
                      location: 'location',
                      size: 4,
                      general_area: 'general_area',
                      accessible: false,
                      notes: 'notes',
                      combination: 'combination',
                      code: 'code',
                      tag: 'tag',
                      discs: 'discs',
                      clutch: 'clutch',
                      hubpos: 'hubpos',
                      key_number: 'num',
                      floor: 1
                    ))
  end

  it 'renders new locker form' do
    render

    assert_select 'form[action=?][method=?]', lockers_path, 'post' do
      assert_select 'input[name=?]', 'locker[location]', value: 'location'

      assert_select 'select[name=?]', 'locker[size]', value: '4'

      assert_select 'select[name=?]', 'locker[general_area]', value: 'general_area'

      assert_select 'input[name=?]', 'locker[accessible]'

      assert_select 'input[name=?]', 'locker[notes]', value: 'notes'

      assert_select 'input[name=?]', 'locker[combination]', value: 'combination'

      assert_select 'input[name=?]', 'locker[code]', value: 'code'

      assert_select 'input[name=?]', 'locker[tag]', value: 'tag'

      assert_select 'input[name=?]', 'locker[discs]', value: 'discs'

      assert_select 'input[name=?]', 'locker[clutch]', value: 'clutch'

      assert_select 'input[name=?]', 'locker[hubpos]', value: 'hubpos'

      assert_select 'input[name=?]', 'locker[key_number]', value: 'num'

      assert_select 'input[name=?]', 'locker[floor]', value: 1
    end
  end
end