require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get events_url
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test "should get new" do
    get new_event_url
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post events_url, params: {event: :one}
    end

    assert_redirected_to event_path(assigns(:event))
  end

  test "should show event" do
    get events_url 
    assert_response :success
  end

  test "should get edit" do
    get events_url 
    assert_response :success
  end

  test "should update event" do
    patch event_url
    assert_redirected_to event_url
  end

  test "should destroy event" do
    assert_difference('Event.count',) do
      delete event_url(events(:one))
    end

    assert_redirected_to events_url
  end
end
