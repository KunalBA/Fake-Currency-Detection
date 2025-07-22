clc;
clear;
close all;

% Load Input ₹500 Currency Image
[file, path] = uigetfile({'*.jpg;*.png;*.jpeg','Image Files'}, 'Select ₹500 Currency Note');
if isequal(file,0)
    disp('User cancelled selection');
    return;
end
currency_img = imread(fullfile(path, file));
figure, imshow(currency_img), title('Input ₹500 Currency Note');

% Load Reference ₹500 Genuine Note
ref_img = imread('500_rupee_genuine.jpg'); % Ensure reference image is in MATLAB directory
figure, imshow(ref_img), title('Reference ₹500 Currency Note');

% Preprocess test image - same pipeline as in original code
test_img_resized = imresize(currency_img, [256, 256]);
test_gray = rgb2gray(test_img_resized);
test_filtered = medfilt2(test_gray);
test_edges = edge(test_filtered, 'Canny');
test_hist = imhist(test_edges);

% Preprocess reference image - same pipeline as in original code
ref_img_resized = imresize(ref_img, [256, 256]);
ref_gray = rgb2gray(ref_img_resized);
ref_filtered = medfilt2(ref_gray);
ref_edges = edge(ref_filtered, 'Canny');
ref_hist = imhist(ref_edges);

% Display preprocessed images
figure;
subplot(2,2,1), imshow(test_edges), title('Test Currency Edge Map');
subplot(2,2,2), imshow(ref_edges), title('Reference Edge Map');
subplot(2,2,3), plot(test_hist), title('Test Currency Histogram');
subplot(2,2,4), plot(ref_hist), title('Reference Histogram');

% Calculate SSIM between the test and reference histograms (not the raw images)
% Convert histograms to 2D for SSIM calculation
test_hist_2d = reshape(test_hist, [size(test_hist,1), 1]);
ref_hist_2d = reshape(ref_hist, [size(ref_hist,1), 1]);
max_size = max(size(test_hist_2d, 1), size(ref_hist_2d, 1));
test_hist_padded = zeros(max_size, 1);
ref_hist_padded = zeros(max_size, 1);
test_hist_padded(1:size(test_hist_2d,1)) = test_hist_2d;
ref_hist_padded(1:size(ref_hist_2d,1)) = ref_hist_2d;

% Convert histograms to uint8 format for SSIM (SSIM requires uint8 or double images)
test_hist_uint8 = uint8(255 * (test_hist_padded / max(test_hist_padded)));
ref_hist_uint8 = uint8(255 * (ref_hist_padded / max(ref_hist_padded)));

% Calculate SSIM using the original method's approach
ssimval = ssim(test_hist_uint8, ref_hist_uint8);
disp(['SSIM Similarity Score: ', num2str(ssimval)]);

% Apply the strict threshold from the original code
if ssimval > 0.9995
    disp('✅ Genuine ₹500 Currency Detected');
    msgbox('✅ Genuine ₹500 Currency Detected', 'Result', 'help');
else
    disp('❌ Fake ₹500 Currency Detected!');
    msgbox('❌ Fake ₹500 Currency Detected!', 'Result', 'error');
end

% Also perform SURF feature matching for additional information
% Extract SURF features from both images
points_test = detectSURFFeatures(test_gray);
points_ref = detectSURFFeatures(ref_gray);
[features_test, valid_points_test] = extractFeatures(test_gray, points_test);
[features_ref, valid_points_ref] = extractFeatures(ref_gray, points_ref);

% Match features
index_pairs = matchFeatures(features_test, features_ref, 'Unique', true);
num_matches = size(index_pairs, 1);
disp(['Number of Matched Features: ', num2str(num_matches)]);

% Display matched features
matched_points_test = valid_points_test(index_pairs(:,1));
matched_points_ref = valid_points_ref(index_pairs(:,2));
figure;
showMatchedFeatures(test_gray, ref_gray, matched_points_test, matched_points_ref, 'montage');
title(['Feature Matching: ' num2str(num_matches) ' matches found']);

% Display final assessment
figure('Position', [300 300 400 200]);
if ssimval > 0.9995
    text(0.1, 0.5, '✅ GENUINE CURRENCY', 'FontSize', 20, 'Color', 'green');
else
    text(0.1, 0.5, '❌ FAKE CURRENCY', 'FontSize', 20, 'Color', 'red');
end
axis off;