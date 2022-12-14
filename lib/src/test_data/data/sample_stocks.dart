// Copyright ©2022, GM Consult (Pty) Ltd.
// BSD 3-Clause License
// All rights reserved

part of '../test_data.dart';

/// A small collection of stock data JSON documents for
/// - AAPL.XNGS,
/// - GOOG:XNGS,
/// - GOOGL:XNGS,
/// - TSLA:XNGS,
const _sampleStocks = {
  'AAPL:XNGS': {
    'country': 'Country.US',
    'currency': 'Currency.USD',
    'description': 'Apple Inc. designs, manufactures, and markets smartphones, '
        'personal computers, tablets, wearables, and accessories worldwide. It '
        'also sells various related services. In addition, the company offers:\n'
        'iPhone, a line of smartphones;\n'
        'Mac, a line of personal computers;\n'
        'iPad, a line of multi-purpose tablets;\n'
        'AirPods Max, an over-ear wireless headphone; and\n'
        'wearables, home, and accessories comprising AirPods, Apple TV, Apple Watch, '
        'Beats products, HomePod, and iPod touch. '
        'Apple also provides AppleCare support services, cloud services and store '
        'services.\n'
        'Apple operates various platforms, including the App Store that '
        'allow customers to discover and download applications and digital content, '
        'such as books, music, video, games, and podcasts. Additionally, the '
        'company offers various services, such as:\n'
        'Apple Arcade, a game subscription service;\n'
        'Apple Music, which offers users a curated listening experience with '
        'on-demand radio stations;\n'
        'Apple News+, a subscription news and magazine service;\n'
        'Apple TV+, which offers exclusive original content;\n'
        'Apple Card, a co-branded credit card;\n'
        'and Apple Pay, a cashless payment service.\n'
        'Apple also licenses its intellectual property.\n'
        'The company serves consumers, small and mid-sized businesses and the '
        'education, enterprise, and government markets. It distributes third-party '
        'applications for its products through the App Store. The company also '
        'sells its products through its retail and online stores, direct sales '
        'force and third-party cellular network carriers, wholesalers, retailers, '
        'and resellers.\n'
        'Apple Inc. was incorporated in 1977 and is headquartered in Cupertino, '
        'California.',
    'entityType': 'SecurityData',
    'exchange': 'Exchange.XNGS',
    'gics': '00000000',
    'hashTag': '#Apple',
    'id': 'AAPL:XNGS',
    'phone': '+1 (408) 996 1010',
    'locale': 'Locale.en_US',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_'
            'black.svg/1024px-Apple_logo_black.svg.png',
    'name': 'Apple Inc',
    'securityGroup': 'SecurityGroup.ES',
    'symbol': 'AAPL',
    'ticker': 'AAPL:XNGS',
    'timestamp': 1648985936008,
    'websiteUrl': 'https://www.apple.com'
  },
  'GOOG:XNGS': {
    'country': 'Country.US',
    'currency': 'Currency.USD',
    'description': 'Alphabet Inc. provides various products and platforms in the '
        'United States, Europe, the Middle East, Africa, the Asia-Pacific, Canada, '
        'and Latin America. It operates through Google Services, Google Cloud, and '
        'Other Bets segments.\n'
        'The Google Services segment offers products and '
        'services, including ads, Android, Chrome, hardware, Gmail, Google Drive, '
        'Google Maps, Google Photos, Google Play, Search, and YouTube. It is also '
        'involved in the sale of apps and in-app purchases and digital content in '
        'the Google Play store, Fitbit wearable devices, Google Nest home '
        'products, Pixel phones, and other devices, as well as in the provision of '
        'YouTube non-advertising services.\n'
        'The Google Cloud segment offers:\n'
        'infrastructure, platform, and other services;\n'
        'Google Workspace that include cloud-based collaboration tools for '
        'enterprises, such as Gmail, Docs, Drive, Calendar, and Meet; and\n'
        'other services for enterprise customers.\n'
        'The Other Bets segment sells health technology and internet services.\n'
        'The company was founded in 1998 and is headquartered in Mountain View, '
        'California.',
    'entityType': 'SecurityData',
    'exchange': 'Exchange.XNGS',
    'hashTag': '#Alphabet',
    'id': 'GOOG:XNGS',
    'phone': '+1 650 253 0000',
    'locale': 'Locale.en_US',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Google_2015'
            '_logo.svg/250px-Google_2015_logo.svg.png',
    'name': 'Alphabet Inc',
    'names': {'en_US': 'Alphabet Inc'},
    'securityGroup': 'SecurityGroup.ES',
    'symbol': 'GOOG',
    'ticker': 'GOOG:XNGS',
    'timestamp': 1648985937537,
    'websiteUrl': 'https://www.abc.xyz'
  },
  'GOOGL:XNGS': {
    'country': 'Country.US',
    'currency': 'Currency.USD',
    'description': 'Alphabet Inc. provides various products and platforms in the '
        'United States, Europe, the Middle East, Africa, the Asia-Pacific, Canada, '
        'and Latin America. It operates through Google Services, Google Cloud, and '
        'Other Bets segments.\n'
        'The Google Services segment offers products and '
        'services, including ads, Android, Chrome, hardware, Gmail, Google Drive, '
        'Google Maps, Google Photos, Google Play, Search, and YouTube. It is also '
        'involved in the sale of apps and in-app purchases and digital content in '
        'the Google Play store, Fitbit wearable devices, Google Nest home '
        'products, Pixel phones, and other devices, as well as in the provision of '
        'YouTube non-advertising services.\n'
        'The Google Cloud segment offers:\n'
        'infrastructure, platform, and other services;\n'
        'Google Workspace that include cloud-based collaboration tools for '
        'enterprises, such as Gmail, Docs, Drive, Calendar, and Meet; and\n'
        'other services for enterprise customers.\n'
        'The Other Bets segment sells health technology and internet services.\n'
        'The company was founded in 1998 and is headquartered in Mountain View,'
        'California.',
    'entityType': 'SecurityData',
    'exchange': 'Exchange.XNGS',
    'gics': '00000000',
    'hashTag': '#Alphabet',
    'id': 'GOOGL:XNGS',
    'phone': '+1 650 253 0000',
    'locale': 'Locale.en_US',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Google_2015'
            '_logo.svg/250px-Google_2015_logo.svg.png',
    'name': 'Alphabet Inc',
    'securityGroup': 'SecurityGroup.ES',
    'symbol': 'GOOGL',
    'ticker': 'GOOGL:XNGS',
    'timestamp': 1656051559982,
    'websiteUrl': 'https://www.abc.xyz'
  },
  'TSLA:XNGS': {
    'country': 'Country.US',
    'currency': 'Currency.USD',
    'description': 'Tesla Inc. designs, develops, manufactures, leases, and '
        'sells electric vehicles, and energy generation and storage systems in the '
        'United States, China, and internationally. \n'
        'The company operates in two segments, Automotive, and Energy Generation '
        'and Storage. \n'
        'The Automotive segment offers electric vehicles, as well as selling '
        'automotive regulatory credits. It provides:\n'
        'sedans and sport utility vehicles through direct and used vehicle sales, '
        'a network of Tesla Superchargers, and in-app upgrades;\n'
        'purchase financing and leasing services;\n'
        '\n'
        'non-warranty after-sales vehicle services, sale of used vehicles;\n'
        '\n'
        'retail merchandise, and vehicle insurance;\n'
        'sale of products to third party customers;\n'
        'services for electric vehicles through its company-owned service locations'
        'and Tesla mobile service technicians; and\n'
        'vehicle limited warranties and extended service plans. \n'
        'The Energy Generation and Storage segment engages in the design, '
        'manufacture, installation, sale, and leasing of solar energy generation '
        'and energy storage products and related services to residential, '
        'commercial, and industrial customers and utilities through its website, '
        'stores, and galleries, as well as through a network of channel partners. '
        'This segment also offers service and repairs to its energy product '
        'customers, including under warranty, and various financing options to '
        'its solar customers. \n'
        'The company was formerly known as Tesla Motors, Inc. and changed its name '
        'to Tesla, Inc. in February 2017.\n'
        'Tesla, Inc. was incorporated in 2003 and is headquartered in Austin, '
        'Texas.',
    'entityType': 'SecurityData',
    'exchange': 'Exchange.XNGS',
    'gics': '00000000',
    'hashTag': '#Tesla',
    'id': 'TSLA:XNGS',
    'phone': '+1 (512) 516-8177',
    'locale': 'Locale.en_US',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Tesla_Motors'
            '.svg/109px-Tesla_Motors.svg.png',
    'name': 'Tesla Inc',
    'securityGroup': 'SecurityGroup.ES',
    'symbol': 'TSLA',
    'ticker': 'TSLA:XNGS',
    'timestamp': 1648985926633,
    'websiteUrl': 'https://www.tesla.com'
  },
};
