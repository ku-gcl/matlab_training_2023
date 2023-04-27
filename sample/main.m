
% plotの設定を読み込む
plotSettings;

% 配列を作成
x = 0:0.1:10;
y = [sin(x); cos(x)];

fig = figure;       % Figureオブジェクトの生成
lines = [animatedline('Color', 'red'); animatedline('Color', 'blue')]; % AnimatedLine オブジェクトの生成
xlim([0 10]); ylim([-1 1]); % 描画範囲の固定
frames(100) = struct('cdata', [], 'colormap', []); % 各フレームの画像データを格納する配列
for i = 1:100 % 動画の長さは100フレームとする
    addpoints(lines(1), x(i), y(1, i)); % 点を追加(sin)
    addpoints(lines(2), x(i), y(2, i)); % 点を追加(cos)
    drawnow; % 描画を確実に実行させる
    frames(i) = getframe(fig); % 図を画像データとして得る
end


% 動画出力用のフォルダを用意
current_path = pwd;     % 現在のパスを取得
folder_name = ['output'];
path = fullfile(current_path, folder_name);  % current_path/folder_name
if not(exist(path, 'dir'))
    % もしoutputフォルダがなければ新規作成する
    mkdir(exportGraphicsPath);
end


% mp4で出力
dtGif = 0;
filename = "output/movie.mp4";
exportType = "mp4";
movieExport(frames, filename, exportType, dtGif);

% Gifで出力
dtGif = 30;
filename = "output/movie.gif";
exportType = "gif";
movieExport(frames, filename, exportType, dtGif);
