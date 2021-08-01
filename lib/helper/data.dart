import 'dart:math';

class StaticData {
  static List<String> sunday = [
    "High-Land Park",
    "Maitri Garden",
    "High-Land Garden",
    "Rustomjee Urbania",
    "Rustomjee Azziano",
    "Parimal",
    "Saraswati CHS",
    "Priyanka CHS",
    "Tirumala",
    "Monte Vista",
    "Ananth Regency",
    "Shayam Kripa",
    "New Shanti Bana",
    "Marathon Olmpiya",
    "Arjun CHS",
    "Om CHS",
    "Punchsheel Building",
    "Everest World",
    "Wadhwa Solitaire",
    "Patel Society",
    "High-Land Recidency",
    "Sumti Dham",
    "Lodha Luxurius",
    "Nishta CHS",
    "BPS Ashtha CHS",
    "Silver Avenue",
    "Silver Court",
    "Blue Bells-A Bld.",
    "Blue Bells-B bld.",
    "Rutu Park",
    "Runwal Pearl",
    "Vasant Fiona"
  ];

  static List<String> tuesday = [
    "Vasant Oscar",
    "Runwal Anthurium",
    "Runwal Pride",
    "Model Town",
    "Shivgiri",
    "Marathon Cosmos",
    "Marathon Galaxy 1&2",
    "Prem Villa",
    "Tulsiram CHS",
    "Punchkamal CHS",
    "Runwal Greens",
    "Kamal Integrated",
    "BPS Ananda & Vardan Society",
    "Kumudini Bld."
  ];

  static List<String> wednesday = [
    "Pine Wood",
    "Red Wood",
    "Teak Wood",
    "Golden Willow",
    "Cypress",
    "Swapna Mahal",
    "Daffodil CHS",
    "Rachna Garden",
    "Om Kripa",
    "Willow Twin Tower",
    "Arihant Kripa",
    "Silver Brich",
    "Sai Ashish",
    "Shree Ram Apt.",
    "Neel Kamal Bld. Akash Deep Society",
    "Vishwadhan CHS",
    "Green Ash",
    "Rajlaxmi CHS",
    "Swapna sagar"
  ];
  static List<String> thursday = [];
  static List<String> friday = [
    "Vasant Oscar",
    "Runwal Anthurium",
    "Runwal Pride",
    "Model Town",
    "Shivgiri",
    "Marathon Cosmos",
    "Marathon Galaxy 1&2",
    "Prem Villa",
    "Tulsiram CHS",
    "Punchkamal CHS",
    "Runwal Greens",
    "Kamal Integrated",
    "BPS Ananda & Vardan Society",
    "Kumudini Bld."
  ];
  static List<String> saturday = [
    "Pine Wood",
    "Red Wood",
    "Teak Wood",
    "Golden Willow",
    "Cypress",
    "Swapna Mahal",
    "Daffodil CHS",
    "Rachna Garden",
    "Om Kripa",
    "Willow Twin Tower",
    "Arihant Kripa",
    "Silver Brich",
    "Sai Ashish",
    "Shree Ram Apt.",
    "Neel Kamal Bld.",
    "Akash Deep Society",
    "Vishwadhan CHS",
    "Green Ash",
    "Rajlaxmi CHS",
    "Swapna sagar",
    "Other"
  ];

  static List<String> facts = [
    "Apple's are rich in fibre but they can also cause high cholesterol",
    "Grapefruit is great for weight loss",
    "Bananas have potassium so they help you feel fuller for longer",
    "Apple help increasing metabolism",
    "Watermelon contains 92% water. Hence, it is called as water-melon",
    "It takes 36 apples to produce a gallon of apple cider",
    "Botanically, a banana is a berry that grows on a herb",
    "Carrots were first grown for medicine and not for food",
    "A pineapple plant produces only one pineapple every 2 years",
    "Watermelons are actually vegetables and are related to cucumbers, pumpkins and squash",
    "Tomatoes come in every colour except blue"
  ];

  static String getFacts() {
    Random r = Random();
    return facts[r.nextInt(facts.length)];
  }
}
