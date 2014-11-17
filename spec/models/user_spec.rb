require 'spec_helper'

describe User do
    let(:user) { FactoryGirl.create(:user) }
    subject { user }

    it { should respond_to(:name) }
    it { should respond_to(:email) }
    it { should respond_to(:password) }  # virtual attribute
    it { should respond_to(:password_digest) }
    it { should respond_to(:authenticate) }

    it { should respond_to(:church) }
    it { should respond_to(:user_rides) }
    it { should respond_to(:rides) }
    it { should respond_to(:rides_provided) }

    it { should be_valid }
    it { should_not be_admin }

    describe "empty name" do
	before { user.name = '' }

	it { should_not be_valid }
    end

    describe "blank name" do
	before { user.name = ' ' }

	it { should_not be_valid }
    end

    describe "empty email" do
	before { user.email = '' }

	it { should_not be_valid }
    end

    describe "blank email" do
	before { user.email = ' ' }

	it { should_not be_valid }
    end

    describe "accepts valid email addresses" do
	valid_addresses = %w[user@example.com
			     USER@foo.COM
			     A_US-ER@foo.bar.org
			     first.last@foo.jp
			     alice+bob@baz.cn]
	it "should accept each address" do
	    valid_addresses.each do |email|
		user.email = email
		should be_valid
	    end
	end
    end

    describe "rejects invalid email addresses" do
	invalid_addresses = %w[user@example,com
			       user_at_foo.org
                               foo@bar_baz.com
			       foo@bar+baz.com]
	it "should reject each address" do
	    invalid_addresses.each do |email|
		user.email = email
		should be_invalid
	    end
	end
    end

    describe "empty password" do
	let (:unsaved_user) { FactoryGirl.build(:user, password: '') }

	specify { expect(unsaved_user).not_to be_valid }
    end

    describe "blank password" do
	let (:unsaved_user) { FactoryGirl.build(:user, password: ' ') }

	specify { expect(unsaved_user).not_to be_valid }
    end

    describe "long name" do
	before { user.name = 'a' * 51 }

	it { should_not be_valid }
    end

    describe "duplicate name" do
	let(:duplicate) do
	    d = user.dup
	    d.email = 'duplicate@example.com'
	    d
	end

	it "is not allowed" do
	    expect(duplicate).not_to be_valid
	end
    end

    describe "duplicate email" do
	let(:duplicate) do
	    d = user.dup
	    d.name = 'Jane Doe'
	    d
	end

	it "is not allowed" do
	    expect(duplicate).not_to be_valid
	end
    end

    describe "administrator account" do
	let (:admin) { FactoryGirl.create(:admin) }

	specify { expect(admin).to be_admin }
    end
end
