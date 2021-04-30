import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CompanyOverview extends StatefulWidget {
  final String symbol;

  CompanyOverview({required this.symbol});

  @override
  _CompanyOverviewState createState() => _CompanyOverviewState();
}

class _CompanyOverviewState extends State<CompanyOverview> {
  late Future<CompanyProfile> futureProfile;

  // TODO: Implement error handling
  Future<CompanyProfile> fetchCompanyProfile() async {
    var dio = Dio();
    final res = await dio.get(
      'https://financialmodelingprep.com/api/v3/profile/${widget.symbol}?apikey=${env['FMP_API_KEY']}',
    );

    if (res.statusCode == 200) {
      final data = res.data as List;
      return new CompanyProfile.fromJson(data, 0);
    }
    return new CompanyProfile(
        companyName: '...', imageUrl: '...', description: '...', price: 0);
  }

  @override
  void initState() {
    super.initState();
    futureProfile = fetchCompanyProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<CompanyProfile>(
        future: futureProfile,
        builder: (context, snapshot) {
          final companyOverview = snapshot.data!;
          return snapshot.hasData
              ? Card(
                  child: Text(companyOverview.companyName),
                )
              : CircularProgressIndicator();
        },
      ),
    );
  }
}

class CompanyProfile {
  final String companyName;
  final String imageUrl;
  final String description;
  final double price;

  CompanyProfile(
      {required this.companyName,
      required this.imageUrl,
      required this.description,
      required this.price});

  factory CompanyProfile.fromJson(List<dynamic> json, int index) =>
      CompanyProfile(
        companyName: json[index]['companyName'],
        imageUrl: json[index]['image'],
        description: json[index]['description'],
        price: json[index]['price'],
      );
}
