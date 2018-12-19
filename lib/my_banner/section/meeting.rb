module MyBanner
  class Section::Meeting

    attr_reader :start_at, :end_at

    def initialize(options={})
      @start_at = options[:start_at]
      @end_at = options[:end_at]
      validate_datetimes
    end

    def to_s
      "#{start_at.try(:strftime, '%Y-%m-%d %H:%M')} ... #{end_at.try(:strftime, '%Y-%m-%d %H:%M')}"
    end

    def to_h
      { start_at: start_at, end_at: end_at }
    end

    private

    def validate_datetimes
      raise "expecting datetimes" unless start_at && end_at && start_at.is_a?(DateTime) && end_at.is_a?(DateTime)
    end

  end
end
