# frozen_string_literal: true

require 'application_system_test_case'

class OpportunitiesTagsTest < ApplicationSystemTestCase
  setup do
    @opportunities_tag = opportunities_tags(:one)
  end

  test 'visiting the index' do
    visit opportunities_tags_url
    assert_selector 'h1', text: 'Opportunities Tags'
  end

  test 'creating a Opportunities tag' do
    visit opportunities_tags_url
    click_on 'New Opportunities Tag'

    fill_in 'Opportunity', with: @opportunities_tag.opportunity_id
    fill_in 'Tag', with: @opportunities_tag.tag_id
    click_on 'Create Opportunities tag'

    assert_text 'Opportunities tag was successfully created'
    click_on 'Back'
  end

  test 'updating a Opportunities tag' do
    visit opportunities_tags_url
    click_on 'Edit', match: :first

    fill_in 'Opportunity', with: @opportunities_tag.opportunity_id
    fill_in 'Tag', with: @opportunities_tag.tag_id
    click_on 'Update Opportunities tag'

    assert_text 'Opportunities tag was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Opportunities tag' do
    visit opportunities_tags_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Opportunities tag was successfully destroyed'
  end
end
