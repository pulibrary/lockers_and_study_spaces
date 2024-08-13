# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'lockers/edit' do
  before do
    @locker = assign(:locker, Locker.create!(
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
                                floor: 'floor'
                              ))
  end

  it 'renders the edit locker form' do
    render

    assert_select 'form[action=?][method=?]', locker_path(@locker), 'post' do
      assert_select 'lux-input-select[name=?]', 'locker[size]'

      assert_select 'lux-input-select[name=?]', 'locker[floor]'

      assert_select 'input[type="checkbox"][name=?]', 'locker[accessible]'

      assert_select 'lux-input-text[name=?]', 'locker[location]'

      assert_select 'lux-input-text[name=?]', 'locker[notes]'

      assert_select 'lux-input-text[name=?]', 'locker[combination]'

      assert_select 'lux-input-text[name=?]', 'locker[code]'

      assert_select 'lux-input-text[name=?]', 'locker[tag]'

      assert_select 'lux-input-text[name=?]', 'locker[discs]'

      assert_select 'lux-input-text[name=?]', 'locker[clutch]'

      assert_select 'lux-input-text[name=?]', 'locker[hubpos]'

      assert_select 'lux-input-text[name=?]', 'locker[key_number]'

      assert_select 'lux-input-text[name=?]', 'locker[general_area]'
    end
  end
end
