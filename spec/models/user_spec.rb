require 'rails_helper'

RSpec.describe User, type: :model do
	let(:user){ User.create(name: 'a', email: 'a@a.com', password: '123456', password_confirmation: '123456') }

  describe 'valid user' do
  	subject{ user }
  	it { is_expected.to respond_to(:name) }
  	it { is_expected.to respond_to(:email) }
  	it { is_expected.to respond_to(:password_digest)}
  	it { is_expected.to respond_to(:password) }
  	it { is_expected.to respond_to(:password_confirmation) }
  	it { is_expected.to respond_to(:authenticate)}
  	it { is_expected.to be_valid }
  end

  describe 'user without name' do
  	let(:user){ User.new(email: 'a@a.com') }
  	subject{ user }
  	it { is_expected.not_to be_valid }
  end

  describe 'user without email' do
  	let(:user){ User.new(name: 'a') }
  	subject{ user }
  	it { is_expected.not_to be_valid }
  end

  describe 'name is too long' do
  	let(:user){ User.new(name: 'a'*51, email: 'a@a.com', password: '123456', password_confirmation: '123456') }
  	subject{ user }
  	it { is_expected.not_to be_valid }
  end

  describe "test emails" do
    it "invalid email formats should not pass" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user.email).to eq(invalid_address)
        expect(user).not_to be_valid
      end
    end

    it "valid email formats should pass" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        user.email = valid_address
        expect(user.email).to eq(valid_address)
        expect(user).to be_valid
      end
    end
  end

  describe 'non-matching passwords' do
		let(:user){ User.new(name: 'a', email: 'a@a.com', password: '123456', password_confirmation: '12345') }
		subject { user }
		it { is_expected.not_to be_valid }
  end

  describe 'password not present' do
		let(:user){ User.new(name: 'a', email: 'a@a.com', password: '123456') }
		subject { user }
		it { is_expected.to be_valid }
  end

  describe 'password too short' do
		let(:user){ User.new(name: 'a', email: 'a@a.com', password: '12345') }
		subject { user }
		it { is_expected.not_to be_valid }
  end

  # Tests not present - testing for valid authentication, doing some of the exercises
	  # describe "return value of authenticate method" do
	  # before { user.save }
	  # let(:found_user) { User.find_by(email: user.email) }

	  # describe "with valid password" do
	  #   it { should eq found_user.authenticate(user.password) }
	  # end

	  # describe "with invalid password" do
	  #   let(:user) { user.authenticate("invalid") }

	  #   it { should_not eq user_for_invalid_password }
	  #    { expect(user_for_invalid_password).to be_false }
	  # end
	# end
  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      user.email = mixed_case_email
      user.save
      expect(user.reload.email).to eq mixed_case_email.downcase
    end
  end
end
