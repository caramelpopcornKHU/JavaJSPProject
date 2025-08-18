CREATE DATABASE IF NOT EXISTS FromJ CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE FromJ;

-- 뉴스 테이블 생성
CREATE TABLE news (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    summary TEXT,
    image_url VARCHAR(500),
    category VARCHAR(50) DEFAULT '축구',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    comment_count INT DEFAULT 0
);

-- 샘플 데이터 삽입
INSERT INTO news (title, summary, image_url, category, comment_count) VALUES
('[1오늘] 맨시티 연패우려, 로제로스 인주력약 수정 안됨', 
 '맨체스터 시티의 최근 경기력 분석', 
 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=60&h=60&fit=crop',
 '해외축구', 12),

('[2더 에셀틱] 로스터리 불현로스, 볼라스 공격력 업승 얘기한 해당 명령', 
 '프리미어리그 최신 이적 소식',
 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=60&h=60&fit=crop',
 '해외축구', 10),
 
 ('[3더 에셀틱] 로스터리 불현로스, 볼라스 공격력 업승 얘기한 해당 명령', 
 '프리미어리그 최신 이적 소식',
 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=60&h=60&fit=crop',
 '해외축구', 10),
 
 ('[4더 에셀틱] 로스터리 불현로스, 볼라스 공격력 업승 얘기한 해당 명령', 
 '프리미어리그 최신 이적 소식',
 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=60&h=60&fit=crop',
 '해외축구', 10),
 
 ('[5더 에셀틱] 로스터리 불현로스, 볼라스 공격력 업승 얘기한 해당 명령', 
 '프리미어리그 최신 이적 소식',
 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=60&h=60&fit=crop',
 '해외축구', 10),
 
 ('[6오늘] 맨시티 연패우려, 로제로스 인주력약 수정 안됨', 
 '맨체스터 시티의 최근 경기력 분석', 
 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=60&h=60&fit=crop',
 '해외축구', 12),
 
('[7더 에셀틱] 로스터리 불현로스, 볼라스 공격력 업승 얘기한 해당 명령', 
 '프리미어리그 최신 이적 소식',
 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=60&h=60&fit=crop',
 '해외축구', 10),
('[8오늘] 맨시티 연패우려, 로제로스 인주력약 수정 안됨', 
 '맨체스터 시티의 최근 경기력 분석', 
 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=60&h=60&fit=crop',
 '해외축구', 12),

('[9더 에셀틱] 로스터리 불현로스, 볼라스 공격력 업승 얘기한 해당 명령', 
 '프리미어리그 최신 이적 소식',
 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=60&h=60&fit=crop',
 '해외축구', 10),
 
 ('[10오늘] 맨시티 연패우려, 로제로스 인주력약 수정 안됨', 
 '맨체스터 시티의 최근 경기력 분석', 
 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=60&h=60&fit=crop',
 '해외축구', 12),

('[11더 에셀틱] 로스터리 불현로스, 볼라스 공격력 업승 얘기한 해당 명령', 
 '프리미어리그 최신 이적 소식',
 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=60&h=60&fit=crop',
 '해외축구', 10),
 
 ('[12오늘] 맨시티 연패우려, 로제로스 인주력약 수정 안됨', 
 '맨체스터 시티의 최근 경기력 분석', 
 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=60&h=60&fit=crop',
 '해외축구', 12),

('[13더 에셀틱] 로스터리 불현로스, 볼라스 공격력 업승 얘기한 해당 명령', 
 '프리미어리그 최신 이적 소식',
 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=60&h=60&fit=crop',
 '해외축구', 10),
 ('[14오늘] 맨시티 연패우려, 로제로스 인주력약 수정 안됨', 
 '맨체스터 시티의 최근 경기력 분석', 
 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=60&h=60&fit=crop',
 '해외축구', 12),

('[15더 에셀틱] 로스터리 불현로스, 볼라스 공격력 업승 얘기한 해당 명령', 
 '프리미어리그 최신 이적 소식',
 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=60&h=60&fit=crop',
 '해외축구', 10),
 ('[16오늘] 맨시티 연패우려, 로제로스 인주력약 수정 안됨', 
 '맨체스터 시티의 최근 경기력 분석', 
 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=60&h=60&fit=crop',
 '해외축구', 12),

('[17더 에셀틱] 로스터리 불현로스, 볼라스 공격력 업승 얘기한 해당 명령', 
 '프리미어리그 최신 이적 소식',
 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=60&h=60&fit=crop',
 '해외축구', 10),
 ('[18오늘] 맨시티 연패우려, 로제로스 인주력약 수정 안됨', 
 '맨체스터 시티의 최근 경기력 분석', 
 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=60&h=60&fit=crop',
 '해외축구', 12),

('[19더 에셀틱] 로스터리 불현로스, 볼라스 공격력 업승 얘기한 해당 명령', 
 '프리미어리그 최신 이적 소식',
 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=60&h=60&fit=crop',
 '해외축구', 10),
 ('[20오늘] 맨시티 연패우려, 로제로스 인주력약 수정 안됨', 
 '맨체스터 시티의 최근 경기력 분석', 
 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=60&h=60&fit=crop',
 '해외축구', 12),

('[21더 에셀틱] 로스터리 불현로스, 볼라스 공격력 업승 얘기한 해당 명령', 
 '프리미어리그 최신 이적 소식',
 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=60&h=60&fit=crop',
 '해외축구', 10)
 ;
 
 -- 리그 순위 테이블 생성
CREATE TABLE league_standings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    league_name VARCHAR(50) NOT NULL, -- 'Premier League' 또는 'La Liga'
    team_name VARCHAR(100) NOT NULL,
    position INT NOT NULL, -- 순위
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


INSERT INTO league_standings (league_name, team_name, position) VALUES
-- 프리미어리그
('Premier League', '맨시티', 1),
('Premier League', '선덜랜드', 2),
('Premier League', '토트넘', 3),
('Premier League', '리버풀', 4),
('Premier League', '브라이턴', 5),
('Premier League', '풀럼', 6),
('Premier League', '애스턴 빌라', 7),
('Premier League', '뉴캐슬', 8),
('Premier League', '아스널', 9),
('Premier League', '첼시', 10),

-- 라리가
('La Liga', '바예카노', 1),
('La Liga', '비야레알', 2),
('La Liga', '바르셀로나', 3),
('La Liga', '마요르카', 4),
('La Liga', '빌바오', 5);

CREATE TABLE breaking_news (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL
);

INSERT INTO breaking_news (title) VALUES
('LIVE: 토트넘 vs 맨시티 2-1 (후반 75분)'),
('속보: 손흥민 시즌 15호골 달성!'),
('News: 15개월 만에 돌아온 조규성'),
('속보: 리버풀 본머스 4-2로 꺾고 EPL 첫 승'),
('황희찬 8분 소화 울버햄튼 맨시티와 EPL 개막전서 0-4 완패');



SELECT * FROM breaking_news ORDER BY id DESC;


-- Safe mode 임시 해제
SET SQL_SAFE_UPDATES = 0;

-- 데이터 삭제
DELETE FROM league_standings;
DELETE FROM breaking_news;

-- Safe mode 다시 활성화
SET SQL_SAFE_UPDATES = 1;

SHOW DATABASES;
USE FromJ;
SHOW TABLES;
SELECT * FROM league_standings;