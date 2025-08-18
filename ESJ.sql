USE FromJ;

CREATE TABLE board (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(20) NOT NULL,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    content TEXT NOT NULL,
    reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    viewboardbreaking_newsleague_standingsnewss INT DEFAULT 0,
    image_files TEXT,
    INDEX idx_category (category),
    INDEX idx_reg_date (reg_date DESC)
);

-- 샘플 데이터
INSERT INTO board (category, title, author, password, content, views) VALUES
('society', '안녕하세요 처음 가입했습니다', '신규회원', '1234', '안녕하세요! 게시판에 처음 가입했습니다.\n잘 부탁드립니다.', 45),
('culture', '오늘 날씨가 정말 좋네요', '날씨맨', 'abcd', '오늘 하늘이 정말 맑고 파랗습니다.\n이런 날에는 밖으로 나가서 산책하는 것이 좋겠어요.', 23),
('economy', '취업 준비 팁 공유합니다', '취준생', 'job123', '취업 준비하면서 도움이 되었던 팁들을 공유합니다.\n면접 준비부터 자기소개서 작성법까지 상세히 설명합니다.', 67),
('politics', '지역 발전을 위한 제안', '시민', 'politics', '우리 지역이 더 발전하기 위해 필요한 것들을 이야기해봅시다.\n지역 경제 활성화와 인프라 개선이 필요합니다.', 89);