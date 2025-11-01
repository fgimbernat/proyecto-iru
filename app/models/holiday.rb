# == Schema Information
#
# Table name: holidays
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  date       :date             not null
#  region_id  :bigint           not null
#  active     :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Holiday < ApplicationRecord
  # Associations
  belongs_to :region

  # Validations
  validates :name, presence: true
  validates :date, presence: true
  validates :date, uniqueness: { scope: :region_id }
  validates :active, inclusion: { in: [true, false] }
  validates :region, presence: true

  # Scopes
  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:date) }
  scope :by_region, ->(region_id) { where(region_id: region_id) }
  scope :upcoming, -> { where('date >= ?', Date.current).ordered }
  scope :past, -> { where('date < ?', Date.current).order(date: :desc) }
  scope :in_year, ->(year) { where('EXTRACT(YEAR FROM date) = ?', year) }
  scope :current_year, -> { in_year(Date.current.year) }

  # Delegations
  delegate :name, to: :region, prefix: true, allow_nil: true

  # Instance methods
  def past?
    date < Date.current
  end

  def upcoming?
    date >= Date.current
  end

  def formatted_date
    I18n.l(date, format: :long)
  end

  def deactivate!
    update(active: false)
  end

  def activate!
    update(active: true)
  end
end
