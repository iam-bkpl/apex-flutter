class QuestionData {
  static const _questions = [
    {
      "question": "What is the purpose of a VPN?",
      "answers": [
        {"id": 1, "text": "Secure remote access", "correct": true},
        {"id": 2, "text": "Speed up internet", "correct": false},
        {"id": 3, "text": "Protect against viruses", "correct": false},
        {"id": 4, "text": "Improve website performance", "correct": false}
      ]
    },
    {
      "question": "Main advantage of cloud computing?",
      "answers": [
        {"id": 1, "text": "Scalability", "correct": true},
        {"id": 2, "text": "Enhanced security", "correct": false},
        {"id": 3, "text": "Data accessibility", "correct": false},
        {"id": 4, "text": "Reliability", "correct": false}
      ]
    },
    {
      "question": "Benefits of using social media?",
      "answers": [
        {"id": 1, "text": "Connect with friends and family", "correct": false},
        {"id": 2, "text": "Discover new content", "correct": false},
        {"id": 3, "text": "Networking opportunities", "correct": true},
        {"id": 4, "text": "Improved communication", "correct": false}
      ]
    },
    {
      "question": "Purpose of a firewall?",
      "answers": [
        {
          "id": 1,
          "text": "Monitor and control network traffic",
          "correct": true
        },
        {"id": 2, "text": "Enhance internet speed", "correct": false},
        {"id": 3, "text": "Protect against hardware failure", "correct": false},
        {"id": 4, "text": "Improve software compatibility", "correct": false}
      ]
    },
    {
      "question": "CPU abbreviation?",
      "answers": [
        {"id": 1, "text": "Central Processing Unit", "correct": true},
        {"id": 2, "text": "Computer Processing Unit", "correct": false},
        {"id": 3, "text": "Centralized Processing Unit", "correct": false},
        {"id": 4, "text": "Computer Performance Unit", "correct": false}
      ]
    },
    {
      "question": "HTML purpose?",
      "answers": [
        {"id": 1, "text": "Define web page structure", "correct": true},
        {"id": 2, "text": "Style web pages", "correct": false},
        {"id": 3, "text": "Provide interactivity", "correct": false},
        {"id": 4, "text": "Manage databases", "correct": false}
      ]
    },
    {
      "question": "Significance of HTTPS?",
      "answers": [
        {
          "id": 1,
          "text": "Ensure secure internet communication",
          "correct": true
        },
        {"id": 2, "text": "Speed up website loading", "correct": false},
        {"id": 3, "text": "Optimize search engine rankings", "correct": false},
        {"id": 4, "text": "Prevent browser crashes", "correct": false}
      ]
    },
    {
      "question": "Purpose of Git?",
      "answers": [
        {
          "id": 1,
          "text": "Track changes and manage software development",
          "correct": true
        },
        {"id": 2, "text": "Enhance graphic design", "correct": false},
        {"id": 3, "text": "Improve system performance", "correct": false},
        {"id": 4, "text": "Optimize server configurations", "correct": false}
      ]
    },
    {
      "question": "What is the purpose of user IDs in DB?",
      "answers": [
        {"id": 1, "text": "Unique identification of users", "correct": true},
        {"id": 2, "text": "User interface customization", "correct": false},
        {"id": 3, "text": "System performance optimization", "correct": false},
        {"id": 4, "text": "Database structure definition", "correct": false}
      ]
    },
    {
      "question": "What does the ID attribute in HTML stand for?",
      "answers": [
        {"id": 1, "text": "Identifier", "correct": true},
        {"id": 2, "text": "Instruction Data", "correct": false},
        {"id": 3, "text": "Interface Definition", "correct": false},
        {"id": 4, "text": "Internal Directory", "correct": false}
      ]
    }
  ];

  static List<Map<String, dynamic>> getQuestions() {
    return _questions;
  }
}
