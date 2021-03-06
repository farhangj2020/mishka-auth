defmodule MishkaAuthTest.Client.UserQueryTest do
  use ExUnit.Case
  alias MishkaAuth.Client.Users.ClientUserQuery

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MishkaAuth.get_config_info(:repo))
  end

  @true_user_parameters %{
    name: "username#{String.downcase(MishkaAuth.Extra.randstring(8))}",
    lastname: "userlastname#{String.downcase(MishkaAuth.Extra.randstring(8))}",
    username: "usernameuniq#{String.downcase(MishkaAuth.Extra.randstring(8))}",
    email: "user_name_#{String.downcase(MishkaAuth.Extra.randstring(8))}@gmail.com",
    password: "pass1Test#{MishkaAuth.Extra.randstring(10)}",
    status: 1,
    unconfirmed_email: "user_name_#{String.downcase(MishkaAuth.Extra.randstring(8))}@gmail.com",
  }


  describe "Happy | User Query basic CRUD (▰˘◡˘▰)" do
    test "add user" do
      {:ok, :add_user, _user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
    end

    test "update user" do
      {:ok, :add_user, user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      {:ok, :edit_user, _updated_user_info} = assert ClientUserQuery.edit_user(user_info.id, @true_user_parameters)
    end

    test "delete user" do
      {:ok, :add_user, user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      {:ok, :delete_user, _struct} = assert ClientUserQuery.delete_user(user_info.id)
    end

    test "find user with email" do
      {:ok, :add_user, user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      {:ok, :find_user_with_email, _user_info} = assert ClientUserQuery.find_user_with_email(user_info.email)
    end

    test "find user with username" do
      {:ok, :add_user, create_user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      {:ok, :find_user_with_username, _user_info} = assert ClientUserQuery.find_user_with_username(create_user_info.username)
    end


    test "find user with user id" do
      {:ok, :add_user, create_user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      {:ok, :find_user_with_user_id, _user_info} = assert ClientUserQuery.find_user_with_user_id(create_user_info.id)
    end

    test "is user activated?" do
      {:ok, :add_user, create_user_info} = assert ClientUserQuery.add_user(@true_user_parameters |> Map.drop([:unconfirmed_email]))
      {:ok, :is_user_activated?, _user_info} = assert ClientUserQuery.is_user_activated?(create_user_info.email)
    end


    test "is is user activated with id" do
      {:ok, :add_user, create_user_info} = assert ClientUserQuery.add_user(@true_user_parameters |> Map.drop([:unconfirmed_email]))
      {:ok, :is_user_activated_with_id?, _user_info} = assert ClientUserQuery.is_user_activated_with_id?(create_user_info.id)
    end

    test "edit user password" do
      {:ok, :add_user, create_user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      {:ok, :edit_user_password, _user_update_info} = assert ClientUserQuery.edit_user_password(create_user_info.email, %{password: "pass1Test#{MishkaAuth.Extra.randstring(10)}"})
    end

    test "edit user verified email" do
      {:ok, :add_user, create_user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      {:ok, :edit_user_verified_email} = assert ClientUserQuery.edit_user_verified_email(create_user_info.email)
    end

    test "valid password" do
      password = "pass1Test#{MishkaAuth.Extra.randstring(10)}"
      {:ok, :add_user, create_user_info} = assert ClientUserQuery.add_user(@true_user_parameters |> Map.merge(%{password: password}))
      {:ok, :valid_password} = assert ClientUserQuery.valid_password(create_user_info, password)
    end

    test "check password user and password -- (:username)" do
      password = "pass1Test#{MishkaAuth.Extra.randstring(10)}"
      {:ok, :add_user, create_user_info} = assert ClientUserQuery.add_user(@true_user_parameters |> Map.merge(%{password: password}))
      {:ok, :check_user_and_password, :username, _user_info} = assert ClientUserQuery.check_user_and_password(create_user_info.username, password, :username)
    end

    test "check password user and password -- (:email)" do
      password = "passT1est#{MishkaAuth.Extra.randstring(10)}"
      {:ok, :add_user, create_user_info} = assert ClientUserQuery.add_user(@true_user_parameters |> Map.merge(%{password: password}))
      {:ok, :check_user_and_password, :email, _user_info} = assert ClientUserQuery.check_user_and_password(create_user_info.email, password, :email)
    end

    test "show public info of user(user_id, :user_id)" do
      {:ok, :add_user, create_user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      {:ok, :show_public_info_of_user, :user_id, _user_info} = assert ClientUserQuery.show_public_info_of_user(create_user_info.id, :user_id)
    end

    test "show public info of user(email, :email)" do
      {:ok, :add_user, create_user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      {:ok, :show_public_info_of_user, :email, _user_info} = assert ClientUserQuery.show_public_info_of_user(create_user_info.email, :email)
    end

    test "edit user password with user id (user_info.id, old_password, new_password)" do
      password = "pass1Test#{MishkaAuth.Extra.randstring(10)}"
      new_password = "pass1Test#{MishkaAuth.Extra.randstring(10)}"

      {:ok, :add_user, user_info} = assert ClientUserQuery.add_user(Map.merge(@true_user_parameters, %{password: password}))

      {:ok, :edit_user_password_with_user_id, _user_update_info} = assert ClientUserQuery.edit_user_password_with_user_id(user_info.id, password, new_password)
    end

    test "add password" do
      new_password = "pass1Test#{MishkaAuth.Extra.randstring(10)}"
      {:ok, :add_user, user_info} = assert ClientUserQuery.add_user(Map.drop(@true_user_parameters, [:password]))
      {:ok, :add_password, _user_update_info} = assert ClientUserQuery.add_password(user_info.id, new_password)
    end

    test "delete password" do
      {:ok, :add_user, add_user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      {:ok, :delete_password, changed_user} = assert ClientUserQuery.delete_password(add_user_info.id)
      {:error, :chack_password_not_null} = assert ClientUserQuery.chack_password_not_null(changed_user.password_hash)
    end

    test "show all users" do
      {:ok, :add_user, _add_user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      [_some_users] = assert ClientUserQuery.show_users()
    end

    test "show users with paginate" do
      {:ok, :add_user, _add_user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      %Scrivener.Page{page_number: 1, page_size: 20, total_entries: 1, total_pages: 1} = assert ClientUserQuery.show_users(1, 20)
    end

    test "show users with paginate and status" do
      {:ok, :add_user, _add_user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      %Scrivener.Page{page_number: 1, page_size: 20, total_entries: 1, total_pages: 1} = assert ClientUserQuery.show_users(1, 20, 1)
    end

    test "send reset password" do
      # needes config email in config
      {:ok, :add_user, user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      {:ok, :reset_password, _user_info} = assert ClientUserQuery.reset_password(user_info.email, "Iran", :email)

      {:ok, :get_data_of_singel_id, record} = MishkaAuth.RedisClient.get_data_of_singel_id("reset_password", user_info.email)
      {:ok, :reset_password, _user_info1} = assert ClientUserQuery.reset_password(user_info.email, record["code"], "Test2121255s", :email)
    end

    test "verify_email" do
      # needes config email in config

      {:ok, :add_user, user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      {:ok, :verify_email, _user_info} = assert ClientUserQuery.verify_email(user_info.email, "Iran", :email)

      {:ok, :get_data_of_singel_id, record} = MishkaAuth.RedisClient.get_data_of_singel_id("verify_email", user_info.email)
      {:ok, :verify_email} = assert ClientUserQuery.verify_email(user_info.email, record["code"], :email, :verify)
    end
  end








  describe "UnHappy | User Query basic CRUD ಠ╭╮ಠ" do
    test "add user" do
      {:error, :add_user, _changeset} = assert ClientUserQuery.add_user(%{email: "test"})
    end

    test "update user -- changeset error (:data_input_problem)" do
      {:ok, :add_user, user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      {:error, :edit_user, :data_input_problem, _changeset} = assert ClientUserQuery.edit_user(user_info.id, %{email: "test"})
    end

    test "update user -- user id error (:user_doesnt_exist)" do
      {:error, :edit_user, :user_doesnt_exist} = assert ClientUserQuery.edit_user(Ecto.UUID.generate, %{email: "test"})
    end

    test "update user -- user id error (:valid_uuid)" do
      {:error, :edit_user, :user_doesnt_exist} = assert ClientUserQuery.edit_user("test", @true_user_parameters)
    end

    test "delete user -- user id error (:user_doesnt_exist)" do
      {:error, :delete_user, :user_doesnt_exist} = assert ClientUserQuery.delete_user(Ecto.UUID.generate)
    end

    test "delete user -- user id error (:valid_uuid)" do
      {:error, :delete_user, :user_doesnt_exist} = assert ClientUserQuery.delete_user("test")
    end

    test "find user with email" do
      {:error, :find_user_with_email} = assert ClientUserQuery.find_user_with_email("email@email.com")
    end

    test "find user with username" do
      {:error, :find_user_with_username} = assert ClientUserQuery.find_user_with_username("test")
    end

    test "find user with user id" do
      {:error, :find_user_with_user_id} = assert ClientUserQuery.find_user_with_user_id(Ecto.UUID.generate)
    end

    test "is user activated? (:user_not_found)" do
      {:error, :is_user_activated?, :user_not_found} = assert ClientUserQuery.is_user_activated?("email@email.com")
    end

    test "is user activated? (:user_not_activated)" do
      {:ok, :add_user, user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      {:error, :is_user_activated?, :user_not_activated} = assert ClientUserQuery.is_user_activated?(user_info.email)
    end

    test "is is user activated with id? (:user_not_found)" do
      {:error, :is_user_activated_with_id?, :user_not_found} = assert ClientUserQuery.is_user_activated_with_id?(Ecto.UUID.generate)
    end

    test "is is user activated with id? (:user_not_activated)" do
      {:ok, :add_user, user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      {:error, :is_user_activated_with_id?, :user_not_activated} = assert ClientUserQuery.is_user_activated_with_id?(user_info.id)
    end

    test "edit user password (:find_user_with_email)" do
      {:error, :edit_user_password, :user_not_found} = assert ClientUserQuery.edit_user_password("email", %{password: "testTest123"})
    end

    test "edit user password (:update_user_password)" do
      {:ok, :add_user, user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      {:error, :edit_user_password, :data_input_problem, _changeset} = assert ClientUserQuery.edit_user_password(user_info.email, %{test: "test"})
    end

    test "edit user verified email" do
      {:error, :edit_user_verified_email, :user_not_found} = assert ClientUserQuery.edit_user_verified_email("email@email.com")
    end

    test "valid password" do
      {:ok, :add_user, create_user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      {:error, :valid_password} = assert ClientUserQuery.valid_password(create_user_info, "#{MishkaAuth.Extra.randstring(10)}")
    end


    test "check password user and password (:username)" do
      {:ok, :add_user, user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      {:error, :check_user_and_password, :username} = assert ClientUserQuery.check_user_and_password(user_info.username, "#{MishkaAuth.Extra.randstring(10)}", :username)
    end

    test "check password user and password (:email)" do
      {:ok, :add_user, user_info} = assert ClientUserQuery.add_user(@true_user_parameters)

      {:error, :check_user_and_password, :email} = assert ClientUserQuery.check_user_and_password(user_info.username, "#{MishkaAuth.Extra.randstring(10)}", :email)
    end

    test "show public info of user(user_id, :user_id)" do
      {:error, :show_public_info_of_user, :user_id} = assert ClientUserQuery.show_public_info_of_user(Ecto.UUID.generate, :user_id)
    end

    test "show public info of user(user_id, :email)" do
      {:error, :show_public_info_of_user, :email} = assert ClientUserQuery.show_public_info_of_user("email@email.com", :email)
    end

    test "edit user password with user id (user not found)" do
      password = "pass1Test#{MishkaAuth.Extra.randstring(10)}"
      new_password = "pass1Test#{MishkaAuth.Extra.randstring(10)}"
      {:ok, :add_user, user_info} = assert ClientUserQuery.add_user(Map.merge(@true_user_parameters, %{password: password}))
      {:ok, :delete_user, _struct} = assert ClientUserQuery.delete_user(user_info.id)

      {:error, :edit_user_password_with_user_id, :user_not_found} = assert ClientUserQuery.edit_user_password_with_user_id(user_info.id, password, new_password)
    end

    test "edit user password with user id (current password)" do
      new_password = "pass1Test#{MishkaAuth.Extra.randstring(10)}"
      {:ok, :add_user, user_info} = assert ClientUserQuery.add_user(@true_user_parameters)

      {:error, :edit_user_password_with_user_id, :current_password} = assert ClientUserQuery.edit_user_password_with_user_id(user_info.id, new_password, new_password)
    end

    test "add_password -- user_not_found" do
      new_password = "pass1Test#{MishkaAuth.Extra.randstring(10)}"
      {:error, :add_password, :user_not_found} = assert ClientUserQuery.add_password(Ecto.UUID.generate, new_password)
    end

    test "add_password -- password_not_null" do
      new_password = "pass1Test#{MishkaAuth.Extra.randstring(10)}"
      {:ok, :add_user, user_info} = assert ClientUserQuery.add_user(@true_user_parameters)
      {:error, :add_password, :password_not_null} = assert ClientUserQuery.add_password(user_info.id, new_password)
    end

    test "delete_password -- user_not_found" do
      {:error, :delete_password, :user_not_found} = assert ClientUserQuery.delete_password(Ecto.UUID.generate)
    end

    test "delete_password -- null_password" do
      {:ok, :add_user, user_info} = assert ClientUserQuery.add_user(Map.drop(@true_user_parameters, [:password]))
      {:error, :delete_password, :null_password} = assert ClientUserQuery.delete_password(user_info.id)
    end

    test "show users all user without paginat" do
      [] = assert ClientUserQuery.show_users()
    end

    test "show users all user with paginat" do
      %Scrivener.Page{entries: [], page_number: 1, page_size: 20, total_entries: 0, total_pages: 1} = assert ClientUserQuery.show_users(1, 20)
    end

    test "show users all user with status" do
      %Scrivener.Page{entries: [], page_number: 1, page_size: 20, total_entries: 0, total_pages: 1} = assert ClientUserQuery.show_users(1, 20, 0)
    end

    test "send reset password" do
      {:error, :reset_password, :find_user_with_email} = assert ClientUserQuery.reset_password("w@w.com", "Iran", :email)
    end

    test "reset password code" do
      {:error, :reset_password, :data_exist, _msg} = assert ClientUserQuery.reset_password("w@w.com", "test", "test123", :email)
    end

    test "verify email" do
      {:error, :verify_email, :find_user_with_email} = assert ClientUserQuery.verify_email("w@w.com", "Iran", :email)
    end

    test "verify email code" do
      {:error, :verify_email, :data_exist, _msg} = assert ClientUserQuery.verify_email("w@w.com", "test", :email, :verify)
    end
  end
end
