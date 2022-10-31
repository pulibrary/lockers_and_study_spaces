# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_applications/show', type: :view do
  let(:user) { FactoryBot.create :user }
  let(:building_one) { FactoryBot.create(:building, id: 1) }
  let(:building_two) { FactoryBot.create(:building, id: 2, name: 'Lewis Library') }

  before do
    building_one
    building_two
    @locker_application = assign(:locker_application, LockerApplication.create!(
                                                        preferred_size: 2,
                                                        preferred_general_area: 'Preferred General Area',
                                                        accessible: false,
                                                        semester: 'Semester',
                                                        status_at_application: 'Stauts At Application',
                                                        department_at_application: 'Department At Application',
                                                        user: user
                                                      ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Preferred General Area/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Semester/)
    expect(rendered).to match(/Stauts At Application/)
    expect(rendered).to match(/Department At Application/)
    expect(rendered).to match(/#{user.uid}/)
  end
end
