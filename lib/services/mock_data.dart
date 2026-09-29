import '../models/candidate.dart';
import '../models/polling_booth.dart';
import '../models/voter_info.dart';
import '../models/civic_report.dart';

/// Prototype Mock Data Repository
///
/// NOTE: The records below represent realistic, curated sample data prepared specifically
/// for college project demonstration and testing. They are not real citizens or real election
/// candidates, in compliance with ethical academic standards.
class MockData {
  // ---------------------------------------------------------------------------
  // SAMPLE CANDIDATES
  // ---------------------------------------------------------------------------
  static List<Candidate> getCandidates() {
    return [
      Candidate(
        id: 'cand-001',
        name: 'Dr. Ananya Sharma',
        constituency: 'North Central Ward 12',
        party: 'Progressive Civic Alliance (Sample)',
        age: '44',
        education: 'Ph.D. in Urban Planning, M.Sc. in Public Policy',
        professionalInformation:
            'Former Senior Research Fellow at Municipal Infrastructure Advisory Board; 12 years in sustainable urban governance.',
        background:
            'Declared public platform focusing on road safety, public transit connectivity, rainwater harvesting mandate, and primary health centre digitisation.',
        source: 'Public Election Commission Affidavit Records (Sample Ref: AFF-2026-NC12-01)',
        declaredAssets: 'Movable: ₹42 Lakhs | Immovable: ₹85 Lakhs (As per Form 26 Affidavit filing)',
      ),
      Candidate(
        id: 'cand-002',
        name: 'Rajesh K. Verma',
        constituency: 'North Central Ward 12',
        party: 'National Democratic Front (Sample)',
        age: '51',
        education: 'B.Com., LL.B., Delhi University',
        professionalInformation:
            'Practicing Advocate in District Civil Court; Former President of Ward Merchant & Trader Welfare Union.',
        background:
            'Declared platform focusing on small business licensing simplification, street vendor zones, LED street lighting upgrades, and civic sanitation reforms.',
        source: 'Public Election Commission Affidavit Records (Sample Ref: AFF-2026-NC12-02)',
        declaredAssets: 'Movable: ₹68 Lakhs | Immovable: ₹1.1 Crore (As per Form 26 Affidavit filing)',
      ),
      Candidate(
        id: 'cand-003',
        name: 'Sunita G. Deshmukh',
        constituency: 'South Ward 15',
        party: 'United Citizens Party (Sample)',
        age: '39',
        education: 'B.E. Civil Engineering, Post Graduate Diploma in Environmental Management',
        professionalInformation:
            'Consultant for Municipal Solid Waste Management; Environmental Auditor for civic infrastructure projects.',
        background:
            'Focus on decentralized waste segregation, storm-water drain overhaul, rejuvenation of ward public parks, and safe pedestrian walkways.',
        source: 'Public Election Commission Affidavit Records (Sample Ref: AFF-2026-SW15-01)',
        declaredAssets: 'Movable: ₹35 Lakhs | Immovable: ₹72 Lakhs (As per Form 26 Affidavit filing)',
      ),
      Candidate(
        id: 'cand-004',
        name: 'Mohammed Tariq Khan',
        constituency: 'South Ward 15',
        party: 'People’s Democratic Congress (Sample)',
        age: '47',
        education: 'M.A. Economics, State University',
        professionalInformation:
            'Social enterprise director, community youth sports council patron, active neighborhood watch coordinator.',
        background:
            'Advocating for 24x7 potable municipal water distribution, youth vocational skilling centers, and regular public grievance redressing camps.',
        source: 'Public Election Commission Affidavit Records (Sample Ref: AFF-2026-SW15-02)',
        declaredAssets: 'Movable: ₹50 Lakhs | Immovable: ₹95 Lakhs (As per Form 26 Affidavit filing)',
      ),
      Candidate(
        id: 'cand-005',
        name: 'Vikramjit Singh Sandhu',
        constituency: 'East Civic District 04',
        party: 'Independent (Sample)',
        age: '34',
        education: 'B.Tech in Computer Science, MBA',
        professionalInformation:
            'Civic Tech entrepreneur; Open Data contributor for local bus transit tracking.',
        background:
            'Independent candidacy advocating for open municipal budget tracking, automated pothole repair monitoring, and ward level air quality sensors.',
        source: 'Public Election Commission Affidavit Records (Sample Ref: AFF-2026-ED04-IND)',
        declaredAssets: 'Movable: ₹28 Lakhs | Immovable: ₹40 Lakhs (As per Form 26 Affidavit filing)',
      ),
      Candidate(
        id: 'cand-006',
        name: 'Meenakshi Iyer',
        constituency: 'West Municipal Sector 09',
        party: 'Progressive Civic Alliance (Sample)',
        age: '49',
        education: 'M.Sc. Nursing Administration, Diploma in Public Health',
        professionalInformation:
            'Senior Community Healthcare Supervisor; active in maternal and child immunization programs.',
        background:
            'Platform emphasizes maternal healthcare accessibility, ward health dispensary modernization, and clean public school drinking water.',
        source: 'Public Election Commission Affidavit Records (Sample Ref: AFF-2026-WS09-01)',
        declaredAssets: 'Movable: ₹38 Lakhs | Immovable: ₹65 Lakhs (As per Form 26 Affidavit filing)',
      ),
    ];
  }

  // ---------------------------------------------------------------------------
  // SAMPLE POLLING BOOTHS
  // ---------------------------------------------------------------------------
  static List<PollingBooth> getPollingBooths() {
    return [
      PollingBooth(
        id: 'booth-101',
        name: 'Community High School - Booth 101',
        boothNumber: 'Booth 101 (Room A-1)',
        address: 'MG Road, Near Gandhi Udyan, North Central Ward 12',
        latitude: 19.0760,
        longitude: 72.8777,
        constituency: 'North Central Ward 12',
        distanceKm: 0.8,
        landmark: 'Opposite Ward Municipal Water Tank',
        wheelchairAccessible: true,
        contactOfficer: 'S. N. Patil (Presiding Officer)',
        contactPhone: '022-2410-1011',
      ),
      PollingBooth(
        id: 'booth-102',
        name: 'Government Primary School - Booth 102',
        boothNumber: 'Booth 102 (Assembly Hall)',
        address: 'Station Road, Sector 3, North Central Ward 12',
        latitude: 19.0820,
        longitude: 72.8840,
        constituency: 'North Central Ward 12',
        distanceKm: 1.4,
        landmark: 'Behind Central Post Office',
        wheelchairAccessible: true,
        contactOfficer: 'P. R. Shinde (Assistant Presiding Officer)',
        contactPhone: '022-2410-1012',
      ),
      PollingBooth(
        id: 'booth-104',
        name: 'ABC Municipal Model School - Booth 104',
        boothNumber: 'Polling Booth 104',
        address: 'Main Road, Civil Lines, South Ward 15',
        latitude: 19.0680,
        longitude: 72.8710,
        constituency: 'South Ward 15',
        distanceKm: 1.2,
        landmark: 'Next to Civic Health Sub-Centre',
        wheelchairAccessible: true,
        contactOfficer: 'K. V. Rao (Sector Officer)',
        contactPhone: '022-2410-1014',
      ),
      PollingBooth(
        id: 'booth-105',
        name: 'St. Jude Community Hall - Booth 105',
        boothNumber: 'Booth 105 (Ground Floor)',
        address: 'Church Avenue, South Ward 15',
        latitude: 19.0620,
        longitude: 72.8680,
        constituency: 'South Ward 15',
        distanceKm: 2.1,
        landmark: 'Near Sacred Heart Convent Gate',
        wheelchairAccessible: false,
        contactOfficer: 'R. K. Menon (Presiding Officer)',
        contactPhone: '022-2410-1015',
      ),
      PollingBooth(
        id: 'booth-106',
        name: 'Municipal Senior Secondary School - Booth 106',
        boothNumber: 'Booth 106 (Room 12)',
        address: 'Bazaar Link Road, East Civic District 04',
        latitude: 19.0910,
        longitude: 72.8950,
        constituency: 'East Civic District 04',
        distanceKm: 3.5,
        landmark: 'Beside District Library',
        wheelchairAccessible: true,
        contactOfficer: 'Anita Kulkarni (Booth Officer)',
        contactPhone: '022-2410-1016',
      ),
      PollingBooth(
        id: 'booth-107',
        name: 'Sector 9 Community Recreation Centre - Booth 107',
        boothNumber: 'Booth 107 (Main Lounge)',
        address: 'Ring Road, Sector 09, West Municipal Sector 09',
        latitude: 19.0550,
        longitude: 72.8590,
        constituency: 'West Municipal Sector 09',
        distanceKm: 4.2,
        landmark: 'Opposite Public Sports Complex Gate 2',
        wheelchairAccessible: true,
        contactOfficer: 'M. S. Chauhan (Presiding Officer)',
        contactPhone: '022-2410-1017',
      ),
    ];
  }

  // ---------------------------------------------------------------------------
  // VOTER INFORMATION & FAQS
  // ---------------------------------------------------------------------------
  static List<VoterInfo> getVoterInformation() {
    return [
      VoterInfo(
        id: 'voter-01',
        name: 'New Voter Registration (Form 6)',
        category: 'Voter Registration',
        summary:
            'Indian citizens who have attained 18 years of age on or before the qualifying date can register as a general elector.',
        eligibility:
            'Must be a citizen of India, aged 18 years or older on qualifying date, and ordinary resident of the polling area.',
        documents: [
          'Proof of Age (Birth Certificate / Class 10 Certificate / PAN / Passport)',
          'Proof of Ordinary Residence (Electricity Bill / Aadhaar / Bank Passbook / Rent Agreement)',
          'Recent Passport-sized color photograph (3.5 cm x 4.5 cm)',
        ],
        steps: [
          'Visit the official National Voters Service Portal (voters.eci.gov.in) or mobile app.',
          'Fill online Form 6 with personal, residential, and family details.',
          'Upload scanned self-attested supporting documents and photograph.',
          'Note down the 12-digit reference acknowledgement number for online tracking.',
          'Booth Level Officer (BLO) performs field verification at residence.',
          'Upon approval, Electoral Photo Identity Card (EPIC) is dispatched via Speed Post.',
        ],
        isOfficialSource: false,
        officialLinks: [
          OfficialLink(
            label: 'National Voters’ Services Portal (Form 6)',
            url: 'https://voters.eci.gov.in',
            authorityName: 'Election Commission of India (ECI)',
          ),
          OfficialLink(
            label: 'Chief Electoral Officer (State CEO)',
            url: 'https://ceoelection.gov.in',
            authorityName: 'State Election Commission Portal',
          ),
        ],
      ),
      VoterInfo(
        id: 'voter-02',
        name: 'Eligibility & Voting Qualifications',
        category: 'Eligibility',
        summary:
            'Understanding who can vote, disqualification clauses, and statutory qualifying dates under the Representation of the People Act.',
        eligibility:
            '1. Citizen of India\n2. Completed 18 years of age\n3. Enrolled in the electoral roll of your constituency\n4. Not disqualified under any prevailing election law.',
        documents: [
          'Valid Voter ID (EPIC) or any of the 12 Election Commission approved photo identity documents (Aadhaar, Passport, Driving License, MNREGA Job Card, etc.) on polling day.',
        ],
        steps: [
          'Check your name in the current Electoral Roll before voting day.',
          'Verify your assigned polling booth and serial number in the voter slip.',
          'Carry an authorized original photo ID card to the polling booth on election day.',
        ],
        isOfficialSource: false,
        officialLinks: [
          OfficialLink(
            label: 'Check Electoral Roll Status Online',
            url: 'https://electoralsearch.eci.gov.in',
            authorityName: 'Election Commission of India',
          ),
        ],
      ),
      VoterInfo(
        id: 'voter-03',
        name: 'Change of Address or Shifting (Form 8)',
        category: 'Address Update',
        summary:
            'If you have shifted residence within the same constituency or moved to another constituency, apply for shifting using Form 8.',
        eligibility:
            'Already registered elector who has shifted residence or requires correction of particulars.',
        documents: [
          'Proof of New Residence (Registered Rent deed, recent utility bill, Aadhaar card with updated address)',
          'Existing Voter ID (EPIC) number',
        ],
        steps: [
          'Log in to the ECI Voter Portal.',
          'Select Form 8: Shifting of Residence / Correction of Entries.',
          'Provide your existing EPIC number to fetch current enrollment details.',
          'Enter new residential address and upload supporting address proof.',
          'Submit the application and track the BLO verification status.',
        ],
        isOfficialSource: false,
        officialLinks: [
          OfficialLink(
            label: 'ECI Form 8 Online Portal',
            url: 'https://voters.eci.gov.in/form8',
            authorityName: 'Election Commission of India',
          ),
        ],
      ),
      VoterInfo(
        id: 'voter-04',
        name: 'Voter ID (e-EPIC) Digital Download',
        category: 'Voter ID Information',
        summary:
            'e-EPIC is a portable document format (PDF) version of the Electoral Photo Identity Card that can be downloaded and stored digitally on DigiLocker.',
        eligibility:
            'All registered voters having unique registered mobile numbers in the ECI database.',
        documents: [
          'EPIC Number or Form Reference Number',
          'Registered Mobile Number for OTP Verification',
        ],
        steps: [
          'Visit voters.eci.gov.in and click on "Download e-EPIC".',
          'Enter your EPIC number or Form Reference Number.',
          'Verify OTP received on your registered mobile number.',
          'Download digitally signed PDF copy of your voter identity card.',
        ],
        isOfficialSource: false,
        officialLinks: [
          OfficialLink(
            label: 'Download e-EPIC Portal',
            url: 'https://voters.eci.gov.in/download-epic',
            authorityName: 'Election Commission of India',
          ),
          OfficialLink(
            label: 'DigiLocker Integration',
            url: 'https://digilocker.gov.in',
            authorityName: 'Ministry of Electronics & IT',
          ),
        ],
      ),
      VoterInfo(
        id: 'voter-05',
        name: 'Frequently Asked Questions (FAQ)',
        category: 'FAQ',
        summary:
            'Common queries regarding election day procedures, voting machines (EVM & VVPAT), and voter rights.',
        isOfficialSource: false,
        faqs: [
          FaqItem(
            question: 'Can I vote if I do not have a physical Voter ID card?',
            answer:
                'Yes, provided your name appears in the current electoral roll. You can carry any of the 12 accepted identity documents including Aadhaar Card, Driving Licence, Passport, or PAN Card.',
          ),
          FaqItem(
            question: 'How do I know which polling booth to visit?',
            answer:
                'Use the Polling Booth Locator in CivicVoice or search on the official ECI Electoral Search portal using your EPIC number. Polling slips are also distributed before election day.',
          ),
          FaqItem(
            question: 'What is VVPAT and how does it work?',
            answer:
                'Voter Verifiable Paper Audit Trail (VVPAT) is an independent verification printer attached to EVMs. When you press a button, a paper slip displays candidate serial number, name, and symbol for 7 seconds through a transparent window before dropping into a sealed box.',
          ),
          FaqItem(
            question: 'What is Form 49-O / NOTA (None of the Above)?',
            answer:
                'The NOTA option is located at the end of the candidate list on every Electronic Voting Machine, allowing citizens to officially record a vote of non-endorsement for all contesting candidates.',
          ),
          FaqItem(
            question: 'Can overseas Indian citizens (NRIs) vote?',
            answer:
                'Yes, overseas electors can enroll by filing Form 6A online. However, under current regulations, they must cast their vote in person at their designated polling station with their original passport.',
          ),
        ],
      ),
    ];
  }

  // ---------------------------------------------------------------------------
  // SAMPLE CIVIC REPORTS
  // ---------------------------------------------------------------------------
  static List<CivicReport> getSampleReports() {
    final now = DateTime.now();
    return [
      CivicReport(
        id: 'CV-2026-0001',
        userId: 'citizen-demo-01',
        title: 'Street Light Not Working',
        category: 'Street Light',
        description:
            'Two consecutive street light poles (Pole #L-42 and #L-43) outside Green Valley Co-operative Housing Society have been completely dark for four days, causing safety concerns for evening commuters.',
        location: 'Green Valley Society Main Gate, North Central Ward 12',
        latitude: 19.0772,
        longitude: 72.8790,
        imageUrl: null,
        status: 'Submitted',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
        statusHistory: [
          ReportStatusLog(
            status: 'Submitted',
            timestamp: now.subtract(const Duration(days: 1)),
            remarks: 'Report registered through CivicVoice portal.',
          ),
        ],
      ),
      CivicReport(
        id: 'CV-2026-0002',
        userId: 'citizen-demo-01',
        title: 'Deep Pothole at Sector 3 Junction',
        category: 'Road',
        description:
            'A large crater-like pothole approximately 1.5 meters wide has formed at the turn towards the Municipal School. Two-wheelers frequently skid during rain.',
        location: 'Junction of 4th Cross and Station Road, North Central Ward 12',
        latitude: 19.0815,
        longitude: 72.8835,
        imageUrl: null,
        status: 'In Progress',
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(hours: 18)),
        statusHistory: [
          ReportStatusLog(
            status: 'Submitted',
            timestamp: now.subtract(const Duration(days: 4)),
            remarks: 'Report logged by citizen.',
          ),
          ReportStatusLog(
            status: 'Under Review',
            timestamp: now.subtract(const Duration(days: 3)),
            remarks: 'Assigned to Ward Roads & Maintenance Junior Engineer.',
          ),
          ReportStatusLog(
            status: 'In Progress',
            timestamp: now.subtract(const Duration(hours: 18)),
            remarks: 'Contractor assigned for cold-mix asphalt patch repair.',
          ),
        ],
      ),
      CivicReport(
        id: 'CV-2026-0003',
        userId: 'citizen-demo-01',
        title: 'Irregular Garbage Collection',
        category: 'Garbage',
        description:
            'Community waste bin overflowing for past 72 hours. Stray cattle and dogs scattering refuse across the public footpath.',
        location: 'Opposite Community Market Gate 2, South Ward 15',
        latitude: 19.0665,
        longitude: 72.8705,
        imageUrl: null,
        status: 'Resolved',
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 5)),
        statusHistory: [
          ReportStatusLog(
            status: 'Submitted',
            timestamp: now.subtract(const Duration(days: 7)),
            remarks: 'Report logged.',
          ),
          ReportStatusLog(
            status: 'Under Review',
            timestamp: now.subtract(const Duration(days: 6)),
            remarks: 'Sanitation Inspector notified.',
          ),
          ReportStatusLog(
            status: 'In Progress',
            timestamp: now.subtract(const Duration(days: 6)),
            remarks: 'Sanitation compactor vehicle dispatched.',
          ),
          ReportStatusLog(
            status: 'Resolved',
            timestamp: now.subtract(const Duration(days: 5)),
            remarks: 'Waste cleared and area sanitized with lime powder.',
          ),
        ],
      ),
    ];
  }
}
