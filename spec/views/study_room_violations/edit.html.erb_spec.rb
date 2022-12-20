# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'study_room_violations/edit' do
  before do
    @study_room_violation = assign(:study_room_violation, FactoryBot.create(:study_room_violation))
  end

  it 'renders the edit violation form' do
    render
    assert_select 'form[action=?][method=?]', study_room_violation_path(@study_room_violation), 'post' do
      assert_select 'input[type=hidden][name=?]', 'study_room_violation[user_id]', count: 0
      assert_select 'input[type=hidden][name=?]', 'study_room_violation[study_room_id]', count: 0
      assert_select 'input-text[name=?]', 'study_room_violation[number_of_books]', count: 0
      expect(rendered).to match(/There is no user currently assigned to the study room!/)
    end
  end

  context 'with an assigned user' do
    before do
      FactoryBot.create(:study_room_assignment, study_room: @study_room_violation.study_room, user: @study_room_violation.user)
    end

    it 'renders the edit violation form' do
      render
      assert_select 'form[action=?][method=?]', study_room_violation_path(@study_room_violation), 'post' do
        assert_select 'input[type=hidden][name=?]', 'study_room_violation[user_id]'
        assert_select 'input[type=hidden][name=?]', 'study_room_violation[study_room_id]'
        assert_select 'input-text[name=?]', 'study_room_violation[number_of_books]'
        expect(rendered).not_to match(/There is no user currently assigned to the study room!/)
      end
    end
  end
end
