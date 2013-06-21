class Database

  ERRORS = {
    :confidential => 'Your voter information cannot be displayed.  Please contact the State Board of Elections for more information.',
    :inactive     => 'Your voter registration is not active.  Please contact the State Board of Elections for more information.'
  }

  DATA = [
    [ "600000000", "norfolk city", "stempinski-04/22/1959-0000-norfolk city",         nil ],
    [ "600000001", "fairfax county", "chriest-04/23/1929-0001-fairfax county",        nil ],
    [ "600000002", "henrico county", "fryrear-06/08/1981-0002-henrico county",        nil ],
    [ "600000003", "loudoun county", "keck-07/05/1939-0003-loudoun county",           nil ],
    [ "600000004", "chesterfield county", "clark-07/04/1962-0004-chesterfield county", nil ],
    [ "600000005", "fairfax county", "smith-11/21/1944-0005-fairfax county",          nil ],
    [ "600000006", "alexandria city", "nahley-10/13/1926-0006-alexandria city",       nil ],
    [ "600000007", "isle of wight county", "harris-10/22/1971-0007-isle of wight county", nil ],
    [ "600000008", "tazewell county", "halperin-01/15/1930-0008-tazewell county",     nil ],
    [ "600000009", "newport news city", "stamper-04/14/1939-0009-newport news city",  :confidential ],
    [ "600000010", "arlington county", "carriger-08/31/1990-0010-arlington county",   nil ],
    [ "600000011", "harrisonburg city", "lewis-10/17/1930-0011-harrisonburg city",    :inactive ],
    [ "600000012", "stafford county", "selfe-08/26/1939-0012-stafford county",        :inactive ],
    [ "600000013", "loudoun county", "wardrick-08/28/1924-0013-loudoun county",       nil ],
    [ "600000014", "norfolk city", "rose-06/07/1928-0014-norfolk city",               nil ],
    [ "600000015", "franklin county", "boisseau-09/18/1922-0015-franklin county",     nil ],
    [ "600000016", "fairfax county", "walton-08/26/1928-0016-fairfax county",         nil ],
    [ "600000017", "spotsylvania county", "costenbader-10/12/1937-0017-spotsylvania county", nil ],
    [ "600000018", "virginia beach city", "phan-11/08/1960-0018-virginia beach city", :inactive ],
    [ "600000019", "virginia beach city", "johnson-06/22/1992-0019-virginia beach city", nil ],
    [ "600000020", "norfolk city", "edlund-04/17/1954-0020-norfolk city",             nil ],
    [ "600000021", "alexandria city", "strong-02/04/1954-0021-alexandria city",       nil ],
    [ "600000022", "stafford county", "suriano-04/20/1987-0022-stafford county",      nil ],
    [ "600000023", "stafford county", "shelton-09/03/1927-0023-stafford county",      nil ],
    [ "600000024", "alexandria city", "de banico-11/25/1970-0024-alexandria city",    nil ],
    [ "600000025", "fairfax county", "obringer-07/17/1936-0025-fairfax county",       nil ],
    [ "600000026", "albemarle county", "brooks-07/28/1947-0026-albemarle county",     nil ],
    [ "600000027", "fairfax county", "bowen-08/16/1966-0027-fairfax county",          nil ],
    [ "600000028", "york county", "kruck-05/26/1946-0028-york county",                nil ],
    [ "600000029", "virginia beach city", "snyder-05/10/1938-0029-virginia beach city", nil ],
    [ "600000030", "newport news city", "flores-06/30/1954-0030-newport news city",   nil ],
    [ "600000031", "mecklenburg county", "whitfield-06/09/1937-0031-mecklenburg county", nil ],
    [ "600000032", "hampton city", "andrews-09/02/1948-0032-hampton city",            nil ],
    [ "600000033", "richmond city", "mcclammer-11/12/1980-0033-richmond city",        nil ],
    [ "600000034", "spotsylvania county", "sherman-07/24/1961-0034-spotsylvania county", nil ],
    [ "600000035", "arlington county", "carlisle-10/20/1941-0035-arlington county",   nil ],
    [ "600000036", "chesapeake city", "chappell-12/06/1925-0036-chesapeake city",     nil ],
    [ "600000037", "fairfax county", "gordon-06/17/1925-0037-fairfax county",         nil ],
    [ "600000038", "arlington county", "bennett-01/06/1932-0038-arlington county",    nil ],
    [ "600000039", "portsmouth city", "howe-05/25/1974-0039-portsmouth city",         :confidential ],
    [ "600000040", "fairfax county", "byrne-10/11/1931-0040-fairfax county",          nil ],
    [ "600000041", "arlington county", "fitzgerald-08/07/1962-0041-arlington county", nil ],
    [ "600000042", "fairfax county", "beckner-07/21/1976-0042-fairfax county",        nil ],
    [ "600000043", "hampton city", "grossman-12/27/1967-0043-hampton city",           :confidential ],
    [ "600000044", "alexandria city", "minnix-03/04/1982-0044-alexandria city",       nil ],
    [ "600000045", "fairfax county", "alexander-07/27/1954-0045-fairfax county",      nil ],
    [ "600000046", "fairfax county", "roberts-06/25/1965-0046-fairfax county",        nil ],
    [ "600000047", "fairfax county", "howell-01/27/1984-0047-fairfax county",         nil ],
    [ "600000048", "albemarle county", "singh-05/03/1955-0048-albemarle county",      nil ],
    [ "600000049", "hampton city", "ohnishi-01/05/1984-0049-hampton city",            nil ],
    [ "611001561", "pittsylvania county", "xxxx-01/01/1984-0000-pittsylvania county", nil ],
    [ "919176144", "newport news city", "xxx-01/01/1984-000-newport news city",       nil ],
    [ "999999998", "fairfax county", "xxx-01/01/1984-000-fairfax county",             nil ],
    [ "999999999", "king & queen county", "xxx-01/01/1984-000-king & queen county",   nil ] ]

  class LookupError < StandardError
    attr_reader :xml

    def initialize(message, xml)
      super message
      @xml = xml
    end

  end

  # looks up XML using whatever data we have.
  # raises an LookupError when confidential or inactive.
  # return HTML for the not found case.
  def self.lookup(voter_id, last_name, dobMonth, dobDay, dobYear, ssn4, locality)
    voter_id  = voter_id.to_s
    locality  = locality.to_s.downcase
    last_name = last_name.to_s.downcase

    if voter_id && !voter_id.empty? && locality && !locality.empty?
      lookup_by_voter_id(voter_id, locality)
    else
      lookup_by_ssn4(last_name, dobMonth, dobDay, dobYear, ssn4, locality)
    end
  end

  private

  # looks up by vid + locality
  def self.lookup_by_voter_id(voter_id, locality)
    DATA.each do |vid, loc, _, code|
      return load_or_raise(vid, code) if voter_id == vid && loc == locality
    end

    load_xml('not_found')
  end

  # looks up by last name + dob + ssn4 + locality
  def self.lookup_by_ssn4(last_name, dobMonth, dobDay, dobYear, ssn4, locality)
    key = "#{last_name}-#{dobMonth.to_s.rjust(2, '0')}/#{dobDay.to_s.rjust(2, '0')}/#{dobYear}-#{ssn4}-#{locality}"
    DATA.each do |vid, _, k, code|
      return load_or_raise(vid, code) if k == key
    end

    load_xml('not_found')
  end

  # loads data or raises an error
  def self.load_or_raise(vid, code)
    raise LookupError.new(ERRORS[code], load_xml(code.to_s)) if code
    load_xml(vid)
  end

  # loads data
  def self.load_xml(voter_id)
    File.open("./data/#{voter_id}").read
  end

end
