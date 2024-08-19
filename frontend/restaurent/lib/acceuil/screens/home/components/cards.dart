import 'package:flutter/material.dart';

class CardPage extends StatelessWidget {
  const CardPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Title",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildCard(Icons.fastfood, "Number of dishes", "150")),
              SizedBox(width: 16), 
              Expanded(child: _buildCard(Icons.people, "Today's customers", "120")),
            ],
          ),
          SizedBox(height: 16), 
          Row(
            children: [
              Expanded(child: _buildCard(Icons.attach_money, "Revenue", "\$2400")),
              SizedBox(width: 16), 
              Expanded(child: _buildCard(Icons.star, "Rating", "4.5")),
            ],
          ),
        
        ],
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, String statistic) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                statistic,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
