class Scheduling < ApplicationRecord

  include SchedulingQuery

  belongs_to :customer
  belongs_to :service
  belongs_to :scheduling_status

  validate :is_available

  scope :not_canceled, -> { where.not(scheduling_status_id: SchedulingStatus::CANCELED) }

  def is_available
    errors.add(:start, :date_invalid) if schedulign_date_is_invalid?
  end

  def schedulign_date_is_invalid?
    return true if Scheduling.where(start: self.start..self.finish).
      where.not(id: self.id, scheduling_status_id: SchedulingStatus::CANCELED).present?
    return true if Scheduling.where(finish: self.start..self.finish).
      where.not(id: self.id, scheduling_status_id: SchedulingStatus::CANCELED).present?
    return true if Scheduling.where("start < ? AND finish > ?", self.start, self.start).
      where.not(id: self.id, scheduling_status_id: SchedulingStatus::CANCELED).present?

    false
  end
end
