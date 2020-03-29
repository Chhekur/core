require 'test_helper'

class RequestHelperTest < ActiveSupport::TestCase
  test '.title_from_response_body parses non-utf8 characters' do
    expected = '«Nous devons agir maintenant», dit Theresa Tam'
    actual = RequestHelper.title_from_response_body("<title>\xC2\xABNous devons agir maintenant\xC2\xBB, dit Theresa Tam</title>")
    assert_equal expected, actual

    expected = 'Why I still use a ThinkPad X220 in 2019 — Maxime Vaillancourt'
    actual = RequestHelper.title_from_response_body("<title>\n    \n      Why I still use a ThinkPad X220 in 2019 &mdash; Maxime Vaillancourt\n    \n  </title>")
    assert_equal expected, actual

    expected = 'Foobar'
    actual = RequestHelper.title_from_response_body("<title data-enabled=\"true\">Foobar</title>")
    assert_equal expected, actual
  end

  test '.url_from_param decodes URIs' do
    expected = "https://2pml.us17.list-manage.com/track/click?u=e5c9ff1dc004212156ddfb8ed&id=1b3cee3d59&e=17acf5a6c2"
    actual = RequestHelper.url_from_param('https%3A%2F%2F2pml.us17.list-manage.com%2Ftrack%2Fclick%3Fu%3De5c9ff1dc004212156ddfb8ed%26id%3D1b3cee3d59%26e%3D17acf5a6c2')
    assert_equal expected, actual

    expected = 'https://google.com'
    actual = RequestHelper.url_from_param('https://google.com')
    assert_equal expected, actual
  end
end
