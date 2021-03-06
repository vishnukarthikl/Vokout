class Owner < ActiveRecord::Base

  belongs_to :facility, dependent: :destroy

  before_save { self.email = email.downcase }
  before_create { generate_token(:auth_token) }
  after_create { send_confirmation_code }

  validates :name,  presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, presence: true, length: { maximum: 255 },
      format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }, allow_blank: true

  has_secure_password

  def Owner.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while Owner.exists?(column => self[column])
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.now
    save!
    OwnerMailer.password_reset(self).deliver_now
  end

  def send_confirmation_code
    generate_token(:confirmation_code)
    self.confirmed = false
    save!
    if !self.is_collaborator
      OwnerMailer.confirmation_code(self).deliver_now
    else
      OwnerMailer.set_password(self).deliver_now
    end

  end

  def confirm
    self.confirmed = true
    save!
  end

end
