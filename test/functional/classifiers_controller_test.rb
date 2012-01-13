require 'test_helper'

class ClassifiersControllerTest < ActionController::TestCase
  setup do
    @classifier = classifiers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:classifiers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create classifier" do
    assert_difference('Classifier.count') do
      post :create, classifier: @classifier.attributes
    end

    assert_redirected_to classifier_path(assigns(:classifier))
  end

  test "should show classifier" do
    get :show, id: @classifier
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @classifier
    assert_response :success
  end

  test "should update classifier" do
    put :update, id: @classifier, classifier: @classifier.attributes
    assert_redirected_to classifier_path(assigns(:classifier))
  end

  test "should destroy classifier" do
    assert_difference('Classifier.count', -1) do
      delete :destroy, id: @classifier
    end

    assert_redirected_to classifiers_path
  end
end
