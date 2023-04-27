% plotの設定を読み込む
plotSettings;

% パラメータ定義
g = 9.81;  % 重力加速度
L = 1.0;   % 振り子の長さ

% 配列を作成
dt = 0.1;
t = 0:dt:10;       % 0秒から10秒のリストを0.1秒間隔で作成
theta0 = pi/4;     % 角度の初期値
omega0 = 0.0;       % 角速度の初期値
x0 = [theta0; omega0];
frames_num = length(t); % 描画するフレーム枚数を取得

[t, x] = ode45(@(t, x) pendulum(t, x, g, L), t, x0);



% 動画を作成する場合は以下をコピーする
fig = figure;       % Figureオブジェクトの生成
lines = [animatedline('Color', 'red'); animatedline('Color', 'blue')]; % AnimatedLine オブジェクトの生成
xlim([0 10]); ylim([-1 1]); % 描画範囲の固定

frames(frames_num) = struct('cdata', [], 'colormap', []); % 各フレームの画像データを格納する配列
for i = 1:frames_num % 動画の長さは100フレームとする
    % 原点と点をプロットする
    plot([0 L*sin(x(i, 1))], [0 -L*cos(x(i, 1))]);
    % グラフの範囲を指定する
    xlim([-L, L]);
    ylim([-L, L]);
    % 描画させる
    % これ以下にはプロット系の宣言を書かないこと
    drawnow; % 描画を確実に実行させる
    frames(i) = getframe(fig); % 図を画像データとして得る
end


% 動画出力用のフォルダを用意
current_path = pwd;     % 現在のパスを取得
folder_name = ['output'];
path = fullfile(current_path, folder_name);  % current_path/folder_name
if not(exist(path, 'dir'))
    % もしoutputフォルダがなければ新規作成する
    mkdir(path);
end


% mp4で出力
dtGif = 0;
filename = "output/movie.mp4";
exportType = "mp4";
movieExport(frames, filename, exportType, dtGif);

% Gifで出力
% dtGif = 30;
dtGif = 1/dt;
filename = "output/movie.gif";
exportType = "gif";
movieExport(frames, filename, exportType, dtGif);

function x = pendulum(t, x, g, L)
    x = [x(2); -g/L*sin(x(1))];
end
