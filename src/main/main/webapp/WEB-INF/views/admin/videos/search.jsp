<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
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
					<div class="alert alert-primary"
						role="alert">
						<i>${message }</i>
						</div>
				</c:if>
				<!-- Het thong bao -->
				<!-- Search -->
				<div class="row mt-2 mb-2">
					<div class="input-md-6">
						<form action="/admin/videos/search">
							<div class="input-group">
								<input type="text"
									class="form-control ml-2" name="name" id="name"
									placeholder="Nhap tu khoa de tim kiem" />
									<button class="btn btn-outline-primary ml-2">Search</button>
							</div>
						</form>						
					</div>
					<div class="col-md-6">
						<div class="float-right">
							<a class="btn btn-outline-success"
								href="/admin/videos/add">Add New Video</a>
						</div>
					</div>
					
				</div>
				
				
				
				
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
					<c:forEach items="${videos }" var="video">
						<tr>
							<td><input type="checkbox" class="form-check-input"> </td>
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
							<td >${video.title } </td>
							<td >${category.views } </td>
							<td >${category.active } </td>
							<td >${video.category.categoryname}</td>
							<td >
								<a href="/admin/videos/view/${video.videoId }"
								class="btn btn-outline-info"><i class="fa fa-info"></i></a>
								<a href="/admin/videos/edit/${video.videoId}"
								class="btn btn-outline-warning"><i class="fa fa-edit"></i> </a>
								<a data-id="${video.videoId }"
									data-name="${video.title }"
									onclick="showconfirmation(this.getAttribute('data-id'),this.getAttribute('data-name'))"
											class="btn btn-outline-danger"><i class="fa fa-trash"></i></a>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				
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
				
				</div>
			</div>
		</div>
			
	</section>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</body>
</html>