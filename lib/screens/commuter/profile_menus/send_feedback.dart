import 'package:flutter/material.dart';
import 'package:carsada_app/components/back_icon.dart';
import 'package:carsada_app/components/button.dart';

class sendFeedback extends StatefulWidget {
  const sendFeedback({super.key});

  @override
  State<sendFeedback> createState() => _sendFeedbackState();
}

class _sendFeedbackState extends State<sendFeedback> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF7F7F9),
      elevation: 0.0,
      leading: Back_Icon(
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text(
            'Feedback',
            style: TextStyle(fontSize: 20, color: Color(0xFF353232)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: appBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 90),
            Center(
              child: Image.asset(
                'lib/assets/images/Logo.png',
                width: 232,
                height: 48.73,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 50),
            ratingSection(),
            const SizedBox(height: 30),
            commentSection(),
            const SizedBox(height: 20),
            sendFeedbackButton(),
          ],
        ),
      ),
    );
  }

  Widget ratingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rating',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF353232),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'How would you rate your experience?',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF353232),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (_rating == index + 1) {
                      _rating = 0;
                    } else {
                      _rating = index + 1;
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: index < _rating ? Colors.amber : Colors.grey,
                    size: 32,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget commentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Comment ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF353232),
                  ),
                ),
                TextSpan(
                  text: '(optional)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF353232),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _commentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Enter your feedback here',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF353232),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sendFeedbackButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: CustomButton(
        text: 'Send feedback',
        onPressed: () {

        },
      ),
    );
  }
}

