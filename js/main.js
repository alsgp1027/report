
  // 페이지가 로드될 때 localStorage에 저장된 이미지가 있는지 확인하고, 있으면 표시
  window.onload = function() {
    const savedImage = localStorage.getItem('profileImage');
    if (savedImage) {
      document.getElementById('profileImage').src = savedImage;
    }
  };

  // 이미지 파일을 읽고 프로필 이미지를 변경하는 함수
  function changeProfileImage(event) {
    const file = event.target.files[0]; // 사용자가 업로드한 파일
    if (file) {
      const reader = new FileReader(); // FileReader를 사용해 파일 읽기
      reader.onload = function(e) {
        // 이미지가 로드되면 프로필 이미지의 src를 변경
        const profileImage = document.getElementById('profileImage');
        profileImage.src = e.target.result;

        // 변경된 이미지를 localStorage에 저장
        localStorage.setItem('profileImage', e.target.result);
      };
      reader.readAsDataURL(file); // 파일을 읽어 DataURL로 변환
    }
  }
