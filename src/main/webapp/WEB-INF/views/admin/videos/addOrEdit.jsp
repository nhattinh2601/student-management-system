<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="/common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
	crossorigin="anonymous">

<title>Hello, world!</title>
</head>
<body>
	<section class="row">
		<div class="col-6 offset-3 mt-4">
			<form action="<c:url value="/admin/videos/saveOrUpdate" /> "
				method="POST" enctype="multipart/form-data">
				<div class="card">
					<div class="card-header">
						<h2>${video.isEdit ? 'Edit Video' :'Add New Video'}</h2>
					</div>
					<div class="card-body">
						<div class="row">
							<div class="col-7">
								<c:if test="${video.isEdit }">
									<div class="mb-3">
										<label for="videoId" class="form-label">Video ID:</label> <input
											type="hidden" value="${video.isEdit }"> <input
											type="text" ${video.isEdit ? 'readonly' : '' }
											class="form-control" value="${video.videoId}" id="videoId"
											name="videoId" aria-describedly="videoIdid"
											placeholder="video Id">
									</div>
								</c:if>
								<div class="mb-3">
									<label for="name" class="form-label">Video Name:</label> <input
										type="text" class="form-control" value="${video.title }"
										id="title" name="title" aria-descibedly="nameid"
										placeholder="video Name">
								</div>

								<div class="mb-3">
									<label for="CategoryId">Category</label> <select
										class="form-select" name="categoryId" aria-label="categoryId"
										id="categoryId">
										<c:forEach items="${categories}" var="item">
											<option value="${item.categoryId }"
												selected="${item.categoryId == video.categoryId ? 'selected':''}">${item.categoryname}</option>
										</c:forEach>
									</select>
								</div>
								<div class="mb-3">
									<label for="description" class="form-label">Description</label>
									<textarea class="form-control" name="description"
										id="description" rows="5">${video.description }</textarea>
								</div>
							</div>
							<div class="col-5">
								<div class="row">
									<div class="mb-3">
										<label for="isSource">Chon noi luu file</label> <select class="form-select"
											name="isSource" aria-label="isSource" id="isSource">
											<option ${video.isSource == true ? 'selected':'' } value="true">Cloudinary
												</option>
											<option ${video.isSource == false ? 'selected':'' } value="false">Server
												</option>
										</select>
									</div>
																
								
									<script type="text/javascript">
										function chooseFile(fileInput) {
											if (fileInput.files
													&& fileInput.files[0]) {
												var reader = new FileReader();
												reader.onLoad = function(e) {
													$('#images').attr('src',
															e.target.result);
												}
												reader
														.readAsDataURL(fileInput.files[0]);
											}
										}
									</script>
									<c:if test="${video.poster != null }">
										<c:choose>
											<c:when test="${video.poster.substring(0,5)=='https' }">
												<img id="images" src="${video.poster}"
											alt="" style="width: 60%" class="img-fuild rounded border">
											</c:when>
											<c:otherwise>
												<img id="images" src="/admin/videos/images/${video.poster}"
											alt="" style="width: 60%" class="img-fuild rounded border">
											</c:otherwise>
										</c:choose>																		
										
									</c:if>
									<c:if test="${video.poster == null }">
										<img id="images" src="/template/images/noimage.jpg" alt=""
											style="width: 60%" >
									</c:if>
									<br />
									<div class="mb-3">
										<label for="imageFile" class="form-label">Image File</label> <input
											type="file" class="form-control-file"
											value="${video.imageFile }" id="imageFile" name="imageFile"
											aria-describedly="imageFile" placeholder="video Image"
											onchange="chooseFile(this)" accept=".jpg, .png">
									</div>
								</div>
								<div class="row">
									<div class="mb-3">
										<label for="active">active</label> <select class="form-select"
											name="active" aria-label="active" id="active">
											<option ${video.active == true ? 'selected':'' } value="true">On
												Sale</option>
											<option ${video.active == false ? 'selected':'' } value="false">Out
												of Stock</option>
										</select>
									</div>
								</div>
							</div>
						</div>
						<div class="row"></div>

					</div>
				</div>
				<div class="card-footer text-muted">
					<div class="row">
						<div class="col-9 float-left">
							<a href="<c:url value="/admin/videos/add"/>"
								class="btn btn-secondary"><i class="fas fa-new"></i>New </a>
							<button class="btn btn-primary"  >
								<i class="fas fa-save"></i>
								<c:if test="${video.isEdit}">
									<span>Update</span>
								</c:if>
								<c:if test="${!video.isEdit}">
									<span>Save</span>
								</c:if>
							</button>
						</div>
						<div class="col-3 float-right">
							<a href="/admin/videos/searchpagenated" class="btn btn-success"><i class="fas fa-bars"></i>List Video</a>
							<c:if test="${video.isEdit }">
								<a href="/admin/videos/delete/${video.videoId }" class="btn btn-danger float-right"><i class="fas fa-bars"></i>Delete</a>
							</c:if>
						</div>
					</div>					
				</div>
			</form>
		</div>
	</section>
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
		crossorigin="anonymous"></script>
</body>
</html>