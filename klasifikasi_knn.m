% Adi Pamungkas, S.Si, M.Si
% Website: https://pemrogramanmatlab.com/
% Email  : adipamungkas@st.fisika.undip.ac.id

clc; clear; close all;

%%% Proses Pelatihan
% membaca file citra
nama_folder = 'data latih';
nama_file = dir(fullfile(nama_folder,'*.jpg'));
jumlah_file = numel(nama_file);
% inisialisasi variabel ciri_latih
ciri_latih = zeros(jumlah_file,7);

for n = 1:jumlah_file
    % membaca citra RGB
    Img = imread(fullfile(nama_folder,nama_file(n).name));
    % konversi citra RGB menjadi grayscale
    Img_gray = rgb2gray(Img);
    % konversi citra grayscale menjadi biner
    bw = im2bw(Img_gray,graythresh(Img_gray));
    % operasi morfologi
    bw = imcomplement(bw);
    bw = imfill(bw,'holes');
    bw = bwareaopen(bw,100);
    % ekstraksi ciri warna RGB
    R = Img(:,:,1);
    G = Img(:,:,2);
    B = Img(:,:,3);
    R(~bw) = 0;
    G(~bw) = 0;
    B(~bw) = 0;
    Red = sum(sum(R))/sum(sum(bw));
    Green = sum(sum(G))/sum(sum(bw));
    Blue = sum(sum(B))/sum(sum(bw));
    % ekstraksi ciri warna HSV
    HSV = rgb2hsv(Img);
    H = HSV(:,:,1);
    S = HSV(:,:,2);
    V = HSV(:,:,3);
    H(~bw) = 0;
    S(~bw) = 0;
    V(~bw) = 0;
    Hue = sum(sum(H))/sum(sum(bw));
    Saturation = sum(sum(S))/sum(sum(bw));
    Value = sum(sum(V))/sum(sum(bw));
    % ekstraksi ciri ukuran
    Area = sum(sum(bw));
    % mengisi hasil ekstraksi ciri pada variabel ciri_latih
    ciri_latih(n,1) = Red;
    ciri_latih(n,2) = Green;
    ciri_latih(n,3) = Blue;
    ciri_latih(n,4) = Hue;
    ciri_latih(n,5) = Saturation;
    ciri_latih(n,6) = Value;
    ciri_latih(n,7) = Area;
end

% standarisasi data
[ciri_latihZ,muZ,sigmaZ] = zscore(ciri_latih);

% pca
[coeff,score_latih,latent,tsquared,explained] = pca(ciri_latihZ);

% inisialisasi variabel kelas_latih
kelas_latih = cell(jumlah_file,1);
% mengisi nama2 sayur pada variabel kelas_latih
for k = 1:7
    kelas_latih{k} = 'kol';
end

for k = 8:11
    kelas_latih{k} = 'sawi';
end

for k = 12:16
    kelas_latih{k} = 'wortel';
end

% ekstrak PC1 & PC2
PC1 = score_latih(:,1);
PC2 = score_latih(:,2);

% kelas kol
x1 = PC1(1:7);
y1 = PC2(1:7);

% kelas sawi
x2 = PC1(8:11);
y2 = PC2(8:11);

% kelas wortel
x3 = PC1(12:16);
y3 = PC2(12:16);

% menampilkan sebaran data pada masing-masing kelas pelatihan
figure
plot(x1,y1,'r.','MarkerSize',30)
hold on
plot(x2,y2,'g.','MarkerSize',30)
plot(x3,y3,'b.','MarkerSize',30)
hold off
grid on
xlabel('PC1')
ylabel('PC2')
legend('kol','sawi','wortel')
title('Sebaran data pelatihan KNN')

% klasifikasi menggunakan knn
Mdl = fitcknn([PC1,PC2],kelas_latih,'NumNeighbors',3);

% menyimpan variabel-variabel hasil pelatihan
save hasil_pelatihan Mdl muZ coeff sigmaZ

%%% Proses Pengujian
% membaca file citra
nama_folder = 'data uji';
nama_file = dir(fullfile(nama_folder,'*.jpg'));
jumlah_file = numel(nama_file);
% inisialisasi variabel ciri_uji
ciri_uji = zeros(jumlah_file,7);

for n = 1:jumlah_file
    % membaca citra RGB
    Img = imread(fullfile(nama_folder,nama_file(n).name));
    % konversi citra RGB menjadi grayscale
    Img_gray = rgb2gray(Img);
    % konversi citra grayscale menjadi biner
    bw = im2bw(Img_gray,graythresh(Img_gray));
    % operasi morfologi
    bw = imcomplement(bw);
    bw = imfill(bw,'holes');
    bw = bwareaopen(bw,100);
    % ekstraksi ciri warna RGB
    R = Img(:,:,1);
    G = Img(:,:,2);
    B = Img(:,:,3);
    R(~bw) = 0;
    G(~bw) = 0;
    B(~bw) = 0;
    Red = sum(sum(R))/sum(sum(bw));
    Green = sum(sum(G))/sum(sum(bw));
    Blue = sum(sum(B))/sum(sum(bw));
    % ekstraksi ciri warna HSV
    HSV = rgb2hsv(Img);
    H = HSV(:,:,1);
    S = HSV(:,:,2);
    V = HSV(:,:,3);
    H(~bw) = 0;
    S(~bw) = 0;
    V(~bw) = 0;
    Hue = sum(sum(H))/sum(sum(bw));
    Saturation = sum(sum(S))/sum(sum(bw));
    Value = sum(sum(V))/sum(sum(bw));
    % ekstraksi ciri ukuran
    Area = sum(sum(bw));
    % mengisi hasil ekstraksi ciri pada variabel ciri_uji
    ciri_uji(n,1) = Red;
    ciri_uji(n,2) = Green;
    ciri_uji(n,3) = Blue;
    ciri_uji(n,4) = Hue;
    ciri_uji(n,5) = Saturation;
    ciri_uji(n,6) = Value;
    ciri_uji(n,7) = Area;
end

% standarisasi ciri uji
ciri_ujiZ = zeros(jumlah_file,7);
for k = 1:jumlah_file
    ciri_ujiZ(k,:) = (ciri_uji(k,:) - muZ)./sigmaZ;
end

% konversi ciri uji ke PC
score_uji = ciri_ujiZ*coeff;

% ekstrak PC1 & PC2
PC1 = score_uji(:,1);
PC2 = score_uji(:,2);

% mengujikan data uji pada knn
hasil_uji = predict(Mdl,[PC1,PC2]);

% menampilkan sebaran data pada masing-masing kelas pelatihan
figure
plot(x1,y1,'r.','MarkerSize',30)
hold on
plot(x2,y2,'g.','MarkerSize',30)
plot(x3,y3,'b.','MarkerSize',30)
grid on

% kelas kol
x1 = [];
y1 = [];
jumlah_kol = 0;
for n = 1:jumlah_file
    if isequal(hasil_uji{n},'kol');
        jumlah_kol = jumlah_kol+1;
        x1(jumlah_kol,1) = PC1(n);
        y1(jumlah_kol,1) = PC2(n);
    end
end

% kelas sawi
x2 = [];
y2 = [];
jumlah_sawi = 0;
for n = 1:jumlah_file
    if isequal(hasil_uji{n},'sawi');
        jumlah_sawi = jumlah_sawi+1;
        x2(jumlah_sawi,1) = PC1(n);
        y2(jumlah_sawi,1) = PC2(n);
    end
end

% kelas wortel
x3 = [];
y3 = [];
jumlah_wortel = 0;
for n = 1:jumlah_file
    if isequal(hasil_uji{n},'wortel');
        jumlah_wortel = jumlah_wortel+1;
        x3(jumlah_wortel,1) = PC1(n);
        y3(jumlah_wortel,1) = PC2(n);
    end
end

% menampilkan sebaran data pada masing-masing kelas pengujian
plot(x1,y1,'cx','LineWidth',4,'MarkerSize',10)
plot(x2,y2,'mx','LineWidth',4,'MarkerSize',10)
plot(x3,y3,'yx','LineWidth',4,'MarkerSize',10)
hold off
xlabel('PC1')
ylabel('PC2')
legend('kol (latih)','sawi (latih)','wortel (latih)',...
    'kol (uji)','sawi (uji)','wortel (uji)')
title('Sebaran data pengujian KNN')