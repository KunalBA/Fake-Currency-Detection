# 💵 Fake Currency Detection Using MATLAB

Detect fake ₹500 currency notes using image processing techniques in MATLAB.  
This project uses grayscale analysis, edge detection, SSIM comparison, and SURF feature matching to determine whether a given currency note is genuine or counterfeit.

---

## 📌 Features

- Accepts any uploaded image of a ₹500 currency note
- Compares with a reference genuine note
- Uses:
  - Grayscale conversion
  - Median filtering
  - Canny edge detection
  - Edge histogram analysis
  - SSIM (Structural Similarity Index)
  - SURF (Speeded-Up Robust Features) matching
- Visual feedback and result display ("Fake" or "Genuine")

---

## 🧭 Flowchart Logic

```text
Step 1.   Start

Step 2.   Initialize Environment
         • Clear variables, close figures

Step 3.   Load Input ₹500 Currency Note
         • User selects image
         • If not selected → Terminate
         • Read and display input

Step 4.   Load Reference ₹500 Genuine Note
         • Load and display stored genuine image

Step 5.   Preprocess Input Image
         • Resize (256x256)
         • Convert to grayscale
         • Apply median filter
         • Canny edge detection
         • Compute edge histogram

Step 6.   Preprocess Reference Image (same steps)

Step 7.   Display Edge Maps and Histograms

Step 8.   Calculate SSIM Similarity
         • Normalize histograms
         • Pad and convert to uint8
         • Calculate SSIM

Step 9.   Check SSIM Threshold
         • If SSIM > 0.9995 → Genuine
         • Else → Fake
         • Display message box result

Step 10.  Perform SURF Feature Matching
         • Detect and match SURF features
         • Display match points

Step 11.  Display Final Classification Message

Step 12.  End
