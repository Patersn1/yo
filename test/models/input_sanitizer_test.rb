require "test_helper"

class InputSanitizerTest < ActiveSupport::TestCase
  test "Sanitizes script tags" do
    malicious_input = "<script>alert('If only you used input sanitization')</script>"
    safe_output = InputSanitizer.sanitize(malicious_input)
    assert_equal "&lt;script&gt;alert(&#39;If only you used input sanitization&#39;)&lt;/script&gt;", safe_output
    assert_not_includes safe_output, "<script>"
  end

  test "Leaves safe input unchanged" do
    normal_text = "We are an organization built upon helping the community."
    assert_equal normal_text, InputSanitizer.sanitize(normal_text)
  end
end