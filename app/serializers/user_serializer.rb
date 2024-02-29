class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :contact, :type
end
