class GemfileReader
  attr_reader :gemfile_text

  REGEX_PATTERN = /^ *gem '[a-z-_0-9]*'/m

  def initialize(gemfile_text)
    @gemfile_text = gemfile_text
  end

  def execute
    gems_text = gemfile_text.scan REGEX_PATTERN
    gems_text.map! { |text| text.scan(/'(.*)'/).first }.flatten!
    transform(gems_text)
  end

  private

  def transform(gems_names)
    gems_names.map { |item| to_model(item) }
  end

  def to_model(item)
    jewel = Jewel.find_or_create_by(name: item)
    jewel.tap do |j|
      j.count += 1
      j.save
    end
  end
end
