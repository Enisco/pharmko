const medicineListJson = [
  {
    "name": "Paracetamol",
    "description": "Pain reliever and fever reducer.",
    "amount": 5.99,
    "expiryDate": "2025-01-01",
    "dosage": "500mg every 4-6 hours",
    "caution": "Avoid alcohol."
  },
  {
    "name": "Ibuprofen",
    "description": "Nonsteroidal anti-inflammatory drug (NSAID).",
    "amount": 7.49,
    "expiryDate": "2024-12-15",
    "dosage": "200mg every 4-6 hours",
    "caution": "Take with food."
  },
  {
    "name": "Amoxicillin",
    "description": "Antibiotic used to treat infections.",
    "amount": 12.99,
    "expiryDate": "2025-03-22",
    "dosage": "500mg every 8 hours",
    "caution": "Complete the full course."
  },
  {
    "name": "Aspirin",
    "description": "Pain reliever and anti-inflammatory drug.",
    "amount": 4.99,
    "expiryDate": "2024-11-30",
    "dosage": "300mg every 4-6 hours",
    "caution": "Avoid in children with fever."
  },
  {
    "name": "Lisinopril",
    "description": "ACE inhibitor used to treat high blood pressure.",
    "amount": 8.99,
    "expiryDate": "2025-07-19",
    "dosage": "10mg once daily",
    "caution": "May cause dizziness."
  },
  {
    "name": "Metformin",
    "description": "Oral diabetes medicine that helps control blood sugar.",
    "amount": 6.79,
    "expiryDate": "2025-04-28",
    "dosage": "500mg twice daily",
    "caution": "Take with food."
  },
  {
    "name": "Atorvastatin",
    "description": "Used to lower cholesterol and triglycerides.",
    "amount": 14.99,
    "expiryDate": "2025-06-30",
    "dosage": "20mg once daily",
    "caution": "Avoid grapefruit."
  },
  {
    "name": "Simvastatin",
    "description": "Statin medication used to control cholesterol levels.",
    "amount": 10.49,
    "expiryDate": "2025-08-12",
    "dosage": "20mg once daily",
    "caution": "Avoid in liver disease."
  },
  {
    "name": "Omeprazole",
    "description": "Proton pump inhibitor used to treat acid reflux.",
    "amount": 9.99,
    "expiryDate": "2025-02-20",
    "dosage": "20mg once daily",
    "caution": "Do not take for more than 14 days."
  },
  {
    "name": "Levothyroxine",
    "description": "Thyroid hormone replacement.",
    "amount": 11.99,
    "expiryDate": "2025-01-10",
    "dosage": "50mcg once daily",
    "caution": "Take on an empty stomach."
  },
  {
    "name": "Hydrochlorothiazide",
    "description": "Diuretic used to treat high blood pressure.",
    "amount": 7.59,
    "expiryDate": "2025-05-03",
    "dosage": "25mg once daily",
    "caution": "May cause frequent urination."
  },
  {
    "name": "Losartan",
    "description":
        "Angiotensin II receptor blocker (ARB) for high blood pressure.",
    "amount": 13.29,
    "expiryDate": "2025-07-07",
    "dosage": "50mg once daily",
    "caution": "Avoid in pregnancy."
  },
  {
    "name": "Furosemide",
    "description": "Loop diuretic used to treat fluid retention.",
    "amount": 6.99,
    "expiryDate": "2025-03-14",
    "dosage": "40mg once daily",
    "caution": "May cause dehydration."
  },
  {
    "name": "Gabapentin",
    "description": "Used to treat nerve pain and seizures.",
    "amount": 12.49,
    "expiryDate": "2025-09-21",
    "dosage": "300mg three times daily",
    "caution": "May cause drowsiness."
  },
  {
    "name": "Albuterol",
    "description": "Bronchodilator used for asthma and COPD.",
    "amount": 18.99,
    "expiryDate": "2024-10-12",
    "dosage": "1-2 puffs every 4-6 hours as needed",
    "caution": "May cause nervousness."
  },
  {
    "name": "Ciprofloxacin",
    "description": "Antibiotic used to treat bacterial infections.",
    "amount": 13.49,
    "expiryDate": "2025-11-01",
    "dosage": "500mg twice daily",
    "caution": "Avoid in children and pregnant women."
  },
  {
    "name": "Cetirizine",
    "description": "Antihistamine used to treat allergies.",
    "amount": 5.49,
    "expiryDate": "2025-04-15",
    "dosage": "10mg once daily",
    "caution": "May cause drowsiness."
  },
  {
    "name": "Montelukast",
    "description": "Leukotriene receptor antagonist used to treat asthma.",
    "amount": 16.29,
    "expiryDate": "2025-06-22",
    "dosage": "10mg once daily",
    "caution": "May cause mood changes."
  },
  {
    "name": "Ranitidine",
    "description": "H2 blocker used to treat acid reflux.",
    "amount": 8.49,
    "expiryDate": "2025-01-30",
    "dosage": "150mg twice daily",
    "caution": "Use with caution in kidney disease."
  },
  {
    "name": "Azithromycin",
    "description": "Antibiotic used to treat bacterial infections.",
    "amount": 15.99,
    "expiryDate": "2025-10-05",
    "dosage": "500mg once daily for 3 days",
    "caution": "Complete the full course."
  },
  {
    "name": "Clopidogrel",
    "description": "Antiplatelet agent used to prevent blood clots.",
    "amount": 21.99,
    "expiryDate": "2025-09-13",
    "dosage": "75mg once daily",
    "caution": "Avoid in active bleeding."
  },
  {
    "name": "Metoprolol",
    "description": "Beta-blocker used to treat high blood pressure and angina.",
    "amount": 9.49,
    "expiryDate": "2025-02-27",
    "dosage": "50mg twice daily",
    "caution": "May cause fatigue."
  },
  {
    "name": "Pantoprazole",
    "description": "Proton pump inhibitor used to treat GERD.",
    "amount": 12.79,
    "expiryDate": "2025-04-08",
    "dosage": "40mg once daily",
    "caution": "Do not crush or chew tablets."
  },
  {
    "name": "Amlodipine",
    "description": "Calcium channel blocker used to treat high blood pressure.",
    "amount": 7.29,
    "expiryDate": "2025-06-18",
    "dosage": "5mg once daily",
    "caution": "May cause swelling."
  },
  {
    "name": "Prednisone",
    "description": "Corticosteroid used to reduce inflammation.",
    "amount": 14.49,
    "expiryDate": "2025-03-02",
    "dosage": "10mg once daily",
    "caution": "Do not stop abruptly."
  },
  {
    "name": "Doxycycline",
    "description": "Antibiotic used to treat bacterial infections.",
    "amount": 11.29,
    "expiryDate": "2025-08-11",
    "dosage": "100mg twice daily",
    "caution": "Avoid sun exposure."
  },
  /*
  {
    "name": "Warfarin",
    "description": "Anticoagulant used to prevent blood clots.",
    "amount": 19.99,
    "expiryDate": "2025-07-25",
    "dosage": "5mg once daily",
    "caution": "Monitor blood clotting time."
  },
  {
    "name": "Citalopram",
    "description": "Antidepressant used to treat depression and anxiety.",
    "amount": 13.79,
    "expiryDate": "2025-09-19",
    "dosage": "20mg once daily",
    "caution": "May take several weeks to work."
  },
  {
    "name": "Zolpidem",
    "description": "Sedative used to treat insomnia.",
    "amount": 17.49,
    "expiryDate": "2025-05-29",
    "dosage": "10mg at bedtime",
    "caution": "May cause sleepwalking."
  },
  {
    "name": "Venlafaxine",
    "description": "Antidepressant used to treat depression and anxiety.",
    "amount": 16.99,
    "expiryDate": "2025-02-05",
    "dosage": "75mg once daily",
    "caution": "May increase blood pressure."
  },
  {
    "name": "Fluticasone",
    "description": "Corticosteroid used to treat nasal congestion and allergies.",
    "amount": 12.99,
    "expiryDate": "2025-04-14",
    "dosage": "1-2 sprays in each nostril once daily",
    "caution": "May cause nosebleeds."
  },
  {
    "name": "Esomeprazole",
    "description": "Proton pump inhibitor used to treat acid reflux.",
    "amount": 11.49,
    "expiryDate": "2025-01-25",
    "dosage": "20mg once daily",
    "caution": "Do not crush or chew capsules."
  },
  {
    "name": "Lorazepam",
    "description": "Benzodiazepine used to treat anxiety and seizures.",
    "amount": 20.49,
    "expiryDate": "2025-08-14",
    "dosage": "1mg 2-3 times daily",
    "caution": "May cause drowsiness."
  },
  {
    "name": "Sertraline",
    "description": "Antidepressant used to treat depression and anxiety.",
    "amount": 14.99,
    "expiryDate": "2025-09-10",
    "dosage": "50mg once daily",
    "caution": "May take several weeks to work."
  },
  {
    "name": "Tamsulosin",
    "description": "Alpha-blocker used to treat enlarged prostate.",
    "amount": 18.79,
    "expiryDate": "2025-06-16",
    "dosage": "0.4mg once daily",
    "caution": "May cause dizziness."
  },
  {
    "name": "Vardenafil",
    "description": "Used to treat erectile dysfunction.",
    "amount": 25.99,
    "expiryDate": "2025-07-22",
    "dosage": "10mg as needed",
    "caution": "Do not take with nitrates."
  },
  {
    "name": "Loratadine",
    "description": "Antihistamine used to treat allergies.",
    "amount": 5.99,
    "expiryDate": "2025-05-13",
    "dosage": "10mg once daily",
    "caution": "Less sedative than other antihistamines."
  },
  {
    "name": "Duloxetine",
    "description": "Used to treat depression, anxiety, and nerve pain.",
    "amount": 22.49,
    "expiryDate": "2025-03-08",
    "dosage": "60mg once daily",
    "caution": "May cause nausea."
  },
  {
    "name": "Bupropion",
    "description": "Antidepressant used to treat depression and help quit smoking.",
    "amount": 19.29,
    "expiryDate": "2025-07-03",
    "dosage": "150mg once daily",
    "caution": "May increase the risk of seizures."
  },
  {
    "name": "Quetiapine",
    "description": "Antipsychotic used to treat bipolar disorder and schizophrenia.",
    "amount": 23.79,
    "expiryDate": "2025-09-28",
    "dosage": "300mg once daily",
    "caution": "May cause weight gain."
  },
  {
    "name": "Acetaminophen",
    "description": "Pain reliever and fever reducer.",
    "amount": 4.99,
    "expiryDate": "2024-11-15",
    "dosage": "500mg every 4-6 hours",
    "caution": "Avoid overdose; can cause liver damage."
  },
  {
    "name": "Mirtazapine",
    "description": "Antidepressant used to treat depression.",
    "amount": 18.59,
    "expiryDate": "2025-02-26",
    "dosage": "30mg once daily at bedtime",
    "caution": "May cause increased appetite."
  },
  {
    "name": "Bisoprolol",
    "description": "Beta-blocker used to treat high blood pressure.",
    "amount": 9.99,
    "expiryDate": "2025-06-02",
    "dosage": "5mg once daily",
    "caution": "May cause fatigue and dizziness."
  },
  {
    "name": "Spironolactone",
    "description": "Diuretic used to treat fluid retention and high blood pressure.",
    "amount": 12.29,
    "expiryDate": "2025-03-19",
    "dosage": "100mg once daily",
    "caution": "May cause high potassium levels."
  },
  {
    "name": "Pregabalin",
    "description": "Used to treat nerve pain and seizures.",
    "amount": 21.79,
    "expiryDate": "2025-04-26",
    "dosage": "150mg twice daily",
    "caution": "May cause dizziness and drowsiness."
  },
  {
    "name": "Rosuvastatin",
    "description": "Statin medication used to control cholesterol levels.",
    "amount": 14.49,
    "expiryDate": "2025-01-05",
    "dosage": "20mg once daily",
    "caution": "Avoid in liver disease."
  },
  {
    "name": "Cefuroxime",
    "description": "Antibiotic used to treat bacterial infections.",
    "amount": 16.99,
    "expiryDate": "2025-05-09",
    "dosage": "500mg twice daily",
    "caution": "Complete the full course."
  },
  {
    "name": "Meloxicam",
    "description": "NSAID used to treat pain and inflammation.",
    "amount": 13.59,
    "expiryDate": "2025-08-19",
    "dosage": "15mg once daily",
    "caution": "Take with food."
  },
  {
    "name": "Fexofenadine",
    "description": "Antihistamine used to treat allergies.",
    "amount": 8.99,
    "expiryDate": "2025-07-17",
    "dosage": "180mg once daily",
    "caution": "Less sedative than other antihistamines."
  },
  {
    "name": "Atenolol",
    "description": "Beta-blocker used to treat high blood pressure.",
    "amount": 10.29,
    "expiryDate": "2025-02-12",
    "dosage": "50mg once daily",
    "caution": "May cause fatigue."
  },
  {
    "name": "Trazodone",
    "description": "Antidepressant used to treat depression and insomnia.",
    "amount": 14.79,
    "expiryDate": "2025-06-21",
    "dosage": "50mg at bedtime",
    "caution": "May cause drowsiness."
  },
  {
    "name": "Methylphenidate",
    "description": "Stimulant used to treat ADHD.",
    "amount": 25.49,
    "expiryDate": "2025-09-03",
    "dosage": "20mg once daily",
    "caution": "May cause decreased appetite."
  },
  {
    "name": "Olmesartan",
    "description": "Angiotensin II receptor blocker (ARB) for high blood pressure.",
    "amount": 17.79,
    "expiryDate": "2025-08-06",
    "dosage": "20mg once daily",
    "caution": "Avoid in pregnancy."
  },
  {
    "name": "Hydrocodone",
    "description": "Opioid used to treat severe pain.",
    "amount": 24.99,
    "expiryDate": "2024-11-08",
    "dosage": "10mg every 4-6 hours as needed",
    "caution": "Risk of addiction and overdose."
  },
  {
    "name": "Carvedilol",
    "description": "Beta-blocker used to treat heart failure and high blood pressure.",
    "amount": 11.99,
    "expiryDate": "2025-07-11",
    "dosage": "6.25mg twice daily",
    "caution": "May cause dizziness."
  },
  {
    "name": "Propranolol",
    "description": "Beta-blocker used to treat high blood pressure and anxiety.",
    "amount": 8.79,
    "expiryDate": "2025-05-17",
    "dosage": "40mg twice daily",
    "caution": "May cause fatigue."
  },
  {
    "name": "Digoxin",
    "description": "Cardiac glycoside used to treat heart failure and arrhythmias.",
    "amount": 15.99,
    "expiryDate": "2025-09-23",
    "dosage": "0.25mg once daily",
    "caution": "Monitor blood levels regularly."
  },
  {
    "name": "Allopurinol",
    "description": "Used to treat gout and kidney stones.",
    "amount": 12.79,
    "expiryDate": "2025-03-05",
    "dosage": "300mg once daily",
    "caution": "Take after meals."
  },
  {
    "name": "Levofloxacin",
    "description": "Antibiotic used to treat bacterial infections.",
    "amount": 19.49,
    "expiryDate": "2025-06-13",
    "dosage": "500mg once daily",
    "caution": "Avoid in pregnancy."
  },
  {
    "name": "Candesartan",
    "description": "Angiotensin II receptor blocker (ARB) for high blood pressure.",
    "amount": 14.99,
    "expiryDate": "2025-07-04",
    "dosage": "8mg once daily",
    "caution": "Avoid in pregnancy."
  },
  {
    "name": "Clindamycin",
    "description": "Antibiotic used to treat bacterial infections.",
    "amount": 13.79,
    "expiryDate": "2025-01-20",
    "dosage": "300mg three times daily",
    "caution": "Complete the full course."
  },
  {
    "name": "Risperidone",
    "description": "Antipsychotic used to treat schizophrenia and bipolar disorder.",
    "amount": 22.29,
    "expiryDate": "2025-02-24",
    "dosage": "2mg once daily",
    "caution": "May cause weight gain."
  },
  {
    "name": "Diclofenac",
    "description": "NSAID used to treat pain and inflammation.",
    "amount": 10.79,
    "expiryDate": "2025-05-31",
    "dosage": "50mg three times daily",
    "caution": "Take with food."
  },
  {
    "name": "Terazosin",
    "description": "Alpha-blocker used to treat high blood pressure and enlarged prostate.",
    "amount": 16.49,
    "expiryDate": "2025-03-18",
    "dosage": "5mg once daily",
    "caution": "May cause dizziness."
  },
  {
    "name": "Finasteride",
    "description": "Used to treat enlarged prostate and hair loss.",
    "amount": 23.99,
    "expiryDate": "2025-08-15",
    "dosage": "1mg once daily",
    "caution": "Not for use by women."
  },
  {
    "name": "Ondansetron",
    "description": "Used to prevent nausea and vomiting.",
    "amount": 9.29,
    "expiryDate": "2025-01-17",
    "dosage": "4mg every 8 hours as needed",
    "caution": "May cause constipation."
  },
  {
    "name": "Glimepiride",
    "description": "Oral diabetes medicine that helps control blood sugar.",
    "amount": 15.29,
    "expiryDate": "2025-04-09",
    "dosage": "2mg once daily",
    "caution": "May cause low blood sugar."
  },
  {
    "name": "Liraglutide",
    "description": "Used to treat type 2 diabetes and obesity.",
    "amount": 30.99,
    "expiryDate": "2025-07-15",
    "dosage": "1.2mg once daily",
    "caution": "May cause nausea."
  },
  {
    "name": "Dapagliflozin",
    "description": "Oral diabetes medicine that helps control blood sugar.",
    "amount": 27.49,
    "expiryDate": "2025-09-26",
    "dosage": "10mg once daily",
    "caution": "May cause dehydration."
  },
  {
    "name": "Vildagliptin",
    "description": "Oral diabetes medicine that helps control blood sugar.",
    "amount": 24.79,
    "expiryDate": "2025-08-29",
    "dosage": "50mg once daily",
    "caution": "Monitor liver function."
  },
  {
    "name": "Pioglitazone",
    "description": "Oral diabetes medicine that helps control blood sugar.",
    "amount": 22.99,
    "expiryDate": "2025-06-05",
    "dosage": "30mg once daily",
    "caution": "May cause weight gain."
  },
  {
    "name": "Canagliflozin",
    "description": "Oral diabetes medicine that helps control blood sugar.",
    "amount": 29.49,
    "expiryDate": "2025-02-03",
    "dosage": "100mg once daily",
    "caution": "May cause dehydration."
  },
  {
    "name": "Gliclazide",
    "description": "Oral diabetes medicine that helps control blood sugar.",
    "amount": 17.29,
    "expiryDate": "2025-03-12",
    "dosage": "80mg once daily",
    "caution": "May cause low blood sugar."
  },
  {
    "name": "Empagliflozin",
    "description": "Oral diabetes medicine that helps control blood sugar.",
    "amount": 28.79,
    "expiryDate": "2025-05-20",
    "dosage": "10mg once daily",
    "caution": "May cause dehydration."
  },
  {
    "name": "Linagliptin",
    "description": "Oral diabetes medicine that helps control blood sugar.",
    "amount": 26.99,
    "expiryDate": "2025-08-23",
    "dosage": "5mg once daily",
    "caution": "Monitor liver function."
  },
  {
    "name": "Sitagliptin",
    "description": "Oral diabetes medicine that helps control blood sugar.",
    "amount": 25.79,
    "expiryDate": "2025-07-28",
    "dosage": "100mg once daily",
    "caution": "Monitor kidney function."
  },
  {
    "name": "Alendronate",
    "description": "Used to treat and prevent osteoporosis.",
    "amount": 13.99,
    "expiryDate": "2025-06-09",
    "dosage": "70mg once weekly",
    "caution": "Take with a full glass of water."
  },
  {
    "name": "Risedronate",
    "description": "Used to treat and prevent osteoporosis.",
    "amount": 15.49,
    "expiryDate": "2025-04-23",
    "dosage": "35mg once weekly",
    "caution": "Remain upright for 30 minutes after taking."
  },
  {
    "name": "Ibandronate",
    "description": "Used to treat and prevent osteoporosis.",
    "amount": 17.99,
    "expiryDate": "2025-09-07",
    "dosage": "150mg once monthly",
    "caution": "Take with a full glass of water."
  },
  {
    "name": "Raloxifene",
    "description": "Used to treat and prevent osteoporosis in postmenopausal women.",
    "amount": 22.49,
    "expiryDate": "2025-05-18",
    "dosage": "60mg once daily",
    "caution": "May increase the risk of blood clots."
  },
  {
    "name": "Calcitriol",
    "description": "Active form of vitamin D used to treat calcium deficiency.",
    "amount": 19.79,
    "expiryDate": "2025-02-21",
    "dosage": "0.25mcg once daily",
    "caution": "Monitor calcium levels regularly."
  }
  */
];
