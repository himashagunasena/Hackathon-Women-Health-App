class Prompt {
  static String diseaseName =
      "Analysis the image and identify the disease and then only return the name of disease";
  static String diseaseAnalysis =
      "Analyze the uploaded image to determine if it contains a human face. If a face is detected and the gender is male, display the message: 'Sorry, this app is only created for detecting women's health conditions.' If the gender cannot be detected or if the image is of a female or a female body part, analyze the skin condition. If a skin condition is identified, display the condition's name as the title in subtitle font size, followed by a detailed explanation of the condition, including symptoms, causes, treatment options, and prevention tips. If no skin condition is detected from human skin, display 'There are no bad health conditions' as the title, along with suggestions for maintaining healthy, clean skin, such as regular cleansing routines, hydration tips, sun protection, and recommended skincare products. If the image does not depict a human or is irrelevant, display the message: 'It is not a disease-related question or it is not human.'";
  static String diseaseAnalysisValue =
      "Analyze the uploaded image to detect the percentage of health based on the visible human body part. Assess the image and identify the percentage of danger related to any detected diseases or conditions of the human body part. Return only the percentage value without the percentage symbol. If there are not bad health condition please return '100'.If the image is not of a human body part, return the message 'e'";
  static String doctorDetails =
      "Analyze the uploaded image to identify the disease and provide the required doctor's specialization. If more than one doctor is needed, return the first specialization followed by the next, separated by a comma.and only return specialization";
  static String doctorDescription =
      "only return given '$doctorDetails' specialist are how to work this disease in order";
}
