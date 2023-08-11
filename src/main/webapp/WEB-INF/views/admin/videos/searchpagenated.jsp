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
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
	integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<title>Hello, world!</title>
</head>
<body>
	<section class="row">
		<div class="col mt-4">
			<div class="card">
				<div class="card-header">List Video</div>
				<div class="card-body">
					<!-- Hien thi thong bao -->
					<c:if test="${message!=null }">
						<div class="alert alert-primary" role="alert">
							<i>${message }</i>
						</div>
					</c:if>
					<!-- Het thong bao -->
					<!-- Search -->
					<div class="row mt-2 mb-2">
						<div class="input-md-6">
							<form action="/admin/videos/searchpagenated">
								<div class="input-group">
									<input type="text" class="form-control ml-2" name="name"
										id="name" placeholder="Nhap tu khoa de tim kiem" />
									<button class="btn btn-outline-primary ml-2">Search</button>
								</div>
							</form>
						</div>
						<div class="col-md-6">
							<div class="float-right">
								<a class="btn btn-outline-success" href="/admin/videos/add">Add
									New Video</a>
							</div>
						</div>

					</div>
					<c:if test="${!videoPage.hasContent()}">
						<div class="row">
							<div class="col">
								<div class="alert alert-danger">Khong tim thay video</div>
							</div>
						</div>
					</c:if>

					<!-- List -->
					<c:if test="${videoPage.hasContent()}">
						<table class="table table-striped table-responsive">
							<thead class="thread-inverse">
								<tr>
									<th>&nbsp;</th>
									<th>Images</th>
									<th>Video Code</th>
									<th>Views</th>
									<th>Status</th>
									<th>Category Name</th>
									<th>Action</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${videoPage.content }" var="video">
									<tr>
										<td><input type="checkbox" class="form-check-input">
										</td>
										<td>
								<c:if test="${video.poster != null }">
										<c:choose>
											<c:when test="${video.poster.substring(0,5) == 'https' }">
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
							</td>
										<td>${video.title }</td>
										<td>${category.views }</td>
										<td>${category.active }</td>
										<td>${video.category.categoryname}</td>
										<td><a href="/admin/videos/view/${video.videoId }"
											class="btn btn-outline-info"><i class="fa fa-info"></i></a> <a
											href="/admin/videos/edit/${video.videoId}"
											class="btn btn-outline-warning"><i class="fa fa-edit"></i>
										</a> <a data-id="${video.videoId }" data-name="${video.title }"
											onclick="showconfirmation(this.getAttribute('data-id'),this.getAttribute('data-name'))"
											class="btn btn-outline-danger"><i class="fa fa-trash"></i></a>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</c:if>

					<script type="text/javascript">
						function showconfirmation(id,name){
							$('#videoTitle').text(name);
							$('#yesOption').attr('href','/admin/videos/delete/' + id);
							$('#confirmationId').modal('show');
						}
					</script>

					<!--Modal  -->
						<div class="modal fade" id="confirmationId" tabindex="-1"
							aria-labelledby="confirmationLabel" aria-hidden="true">
							<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<h5 class="modal-title" id="confirmationLabel">Confirmation</h5>
									<button type="button" class="btn-close" data-bs-dismiss="modal"
										aria-label="Close"></button>
								</div>
								<div class="modal-body">
									Ban co muon xoa "<span id="videoTitle"></span>"?
								</div>
								<div class="modal-footer">
									<a id="yesOption" class="btn btn-secondary">Yes</a>
									<button type="button" class="btn btn-secondary"
										data-bs-dismiss="modal">Close</button>
								</div>
								</div>
							</div>	
						</div>
					
					<!--Modal  -->


					<div class="row">
						<div class="col-5">
							<form action="">
								<div class="mb-3 input-group float-left">
									<label for="size" class="mr-2">Page size:</label> <select
										class="form-select ml-2" name="size" aria-label="size"
										id="size" onchange="this.form.submit()">
										<option ${videoPage.size == 3 ? 'selected':'' } value="3">3</option>
										<option ${videoPage.size == 5 ? 'selected':'' } value="5">5</option>
										<option ${videoPage.size == 10 ? 'selected':'' } value="10">10</option>
										<option ${videoPage.size == 15 ? 'selected':'' } value="15">15</option>
										<option ${videoPage.size == 20 ? 'selected':'' } value="20">20</option>
									</select>
								</div>
							</form>
						</div>
						<div class="col-7">
							<!-- Phan trang  -->
							<c:if test="${videoPage.totalPages >0 }">
								<nav aria-label="Page navigation">
									<ul class="pagination">
										<li
											class="${1==videoPage.number + 1 ? 'page-item active':'page-item' }">
											<a class="page-link"
											href="<c:url value='/admin/videos/searchpagenated?name=${title}&size=${videoPage.size}&page=${1}' />"
											tabindex="-1" aria-disabled="true">First</a>
										</li>

										<c:forEach items="${pageNumbers }" var="pageNumber">
											<c:if test="${videoPage.totalPages > 1 }">
												<li
													class="${pageNumber == videoPage.number + 1 ? 'page-item active' : 'page-item'  }">
													<a class="page-link"
													href="<c:url value='/admin/videos/searchpagenated?name=${title}&size=${videoPage.size}&page=${pageNumber}'/>">${pageNumber}</a>
												</li>
											</c:if>
										</c:forEach>

										<li
											class="${videoPage.totalPages == videoPage.number + 1 ? 'page-item active' : 'page-item'  }">
											<a
											href="<c:url value='/admin/videos/searchpagenated?name=${title}&size=${videoPage.size}&page=${videoPage.totalPages}'/>"
											class="page-link">Last</a>
										</li>
									</ul>
								</nav>
							</c:if>
							<!-- Ket thuc phan trang -->
						</div>
					</div>





				</div>
			</div>
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