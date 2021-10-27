# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'lockers/new', type: :view do
  before(:each) do
    assign(:locker, Locker.new(
                      location: 'MyString',
                      size: 1,
                      general_area: 'MyString',
                      accessible: false,
                      notes: 'MyString',
                      combination: 'MyString',
                      code: 'MyString',
                      tag: 'MyString',
                      discs: 'MyString',
                      clutch: 'MyString',
                      hubpos: 'MyString',
                      key_number: 'MyString',
                      floor: 1
                    ))
  end

  it 'renders new locker form' do
    render

    assert_select 'form[action=?][method=?]', lockers_path, 'post' do
      assert_select 'input[name=?]', 'locker[location]'

      assert_select 'input[name=?]', 'locker[size]'

      assert_select 'input[name=?]', 'locker[general_area]'

      assert_select 'input[name=?]', 'locker[accessible]'

      assert_select 'input[name=?]', 'locker[notes]'

      assert_select 'input[name=?]', 'locker[combination]'

      assert_select 'input[name=?]', 'locker[code]'

      assert_select 'input[name=?]', 'locker[tag]'

      assert_select 'input[name=?]', 'locker[discs]'

      assert_select 'input[name=?]', 'locker[clutch]'

      assert_select 'input[name=?]', 'locker[hubpos]'

      assert_select 'input[name=?]', 'locker[key_number]'

      assert_select 'input[name=?]', 'locker[floor]'
    end
  end
end
