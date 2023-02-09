# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_applications/show' do
  let(:user) { FactoryBot.create(:user) }
  let(:building_one) { FactoryBot.create(:building, id: 1) }
  let(:building_two) { FactoryBot.create(:building, id: 2, name: 'Lewis Library') }

  before do
    building_one
    building_two
    @locker_application = assign(:locker_application, LockerApplication.create!(
                                                        preferred_size: 2,
                                                        preferred_general_area: 'Preferred General Area',
                                                        accessibility_needs: ['Need one', 'Need two'],
                                                        accessible: false,
                                                        semester: 'Semester',
                                                        status_at_application: 'Status At Application',
                                                        department_at_application: 'Department At Application',
                                                        user:
                                                      ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Preferred General Area/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Semester/)
    expect(rendered).to match(/Status At Application/)
    expect(rendered).to match(/Department At Application/)
    expect(rendered).to match(/Need one/)
    expect(rendered).to match(/Need two/)
    expect(rendered).to match(/#{user.uid}/)
  end
end
