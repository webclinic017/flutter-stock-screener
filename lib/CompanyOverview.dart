import 'package:flutter/material.dart';

class CompanyOverview extends StatefulWidget {
  final String symbol;

  CompanyOverview({required this.symbol});

  @override
  _CompanyOverviewState createState() => _CompanyOverviewState();
}

class _CompanyOverviewState extends State<CompanyOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(widget.symbol),
      ),
    );
  }
}
