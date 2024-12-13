<script>
  // 이미지 파일을 읽고 프로필 이미지를 변경하는 함수
    function changeProfileImage(event) {}
    const file = event.target.files[0]; // 사용자가 업로드한 파일
    if (file) {}
    const reader = new FileReader(); // FileReader를 사용해 파일 읽기
    reader.onload = function(e) {
        // 이미지가 로드되면 프로필 이미지의 src를 변경
        document.getElementById('profileImage').src = e.target.result};
      };
    reader.readAsDataURL(file); // 파일을 읽어 DataURL로 변환
    }
  }
</script>;
