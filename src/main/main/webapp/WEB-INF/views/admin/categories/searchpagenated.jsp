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
				<div class="card-header">List Category</div>
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
							<form action="/admin/categories/searchpagenated">
								<div class="input-group">
									<input type="text" class="form-control ml-2" name="name"
										id="name" placeholder="Nhap tu khoa de tim kiem" />
									<button class="btn btn-outline-primary ml-2">Search</button>
								</div>
							</form>
						</div>
						<div class="col-md-6">
							<div class="float-right">
								<a class="btn btn-outline-success" href="/admin/categories/add">Add
									New Category</a>
							</div>
						</div>

					</div>
					<c:if test="${!categoryPage.hasContent()}">
						<div class="row">
							<div class="col">
								<div class="alert alert-danger">Khong tim thay category</div>
							</div>
						</div>
					</c:if>

					<!-- List -->
					<c:if test="${categoryPage.hasContent()}">
						<table class="table table-striped table-responsive">
							<thead class="thread-inverse">
								<tr>
									<th>Category ID</th>
									<th>Category Code</th>
									<th>Category Name</th>
									<th>Status</th>
									<th>Action</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${categoryPage.content }" var="category">
									<tr>
										<td scope="row">${category.categoryId }</td>
										<td>${category.categorycode }</td>
										<td>${category.categoryname }</td>
										<td>${category.status ? 'Hoạt động':'Khóa' }</td>
										<td><a
											href="/admin/categories/view/${category.categoryId }"
											class="btn btn-outline-info"> <i class="fa fa-info"></i>
										</a> <a href="/admin/categories/edit/${category.categoryId }"
											class="btn btn-outline-warning"> <i class="fa fa-edit"></i>
										
										
										</a> <a 
												data-id="${category.categoryId }"
												data-name="${category.categoryname }"
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
							$('#categoryName').text(name);
							$('#yesOption').attr('href','/admin/categories/delete/' + id);
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
									Ban co muon xoa "<span id="categoryName"></span>"?
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
									<label for="size" class="mr-2">Page size:</label>
									<select class="form-select ml-2"
									name="size" aria-label="size" id="size"
									onchange="this.form.submit()">
								<option ${categoryPage.size == 3 ? 'selected':'' } value="3">3</option>
								<option ${categoryPage.size == 5 ? 'selected':'' } value="5">5</option>
								<option ${categoryPage.size == 10 ? 'selected':'' } value="10">10</option>
								<option ${categoryPage.size == 15 ? 'selected':'' } value="15">15</option>
								<option ${categoryPage.size == 20 ? 'selected':'' } value="20">20</option>
									</select>
								</div>
							</form>
						</div>
						<div class="col-7">
							<!-- Phan trang  -->
					<c:if test="${categoryPage.totalPages >0 }">
						<nav aria-label="Page navigation">
							<ul class="pagination">
								<li
									class="${1==categoryPage.number + 1 ? 'page-item active':'page-item' }">
									<a class="page-link"
									href="<c:url value='/admin/categories/searchpagenated?name=${categoryname}&size=${categoryPage.size}&page=${1}' />"
									tabindex="-1" aria-disabled="true">First</a>
								</li>

								<c:forEach items="${pageNumbers }" var="pageNumber">
									<c:if test="${categoryPage.totalPages > 1 }">
										<li
											class="${pageNumber == categoryPage.number + 1 ? 'page-item active' : 'page-item'  }">
											<a class="page-link"
											href="<c:url value='/admin/categories/searchpagenated?name=${categoryname}&size=${categoryPage.size}&page=${pageNumber}'/>">${pageNumber}</a>
										</li>
									</c:if>
								</c:forEach>

								<li
									class="${categoryPage.totalPages == categoryPage.number + 1 ? 'page-item active' : 'page-item'  }">
									<a
									href="<c:url value='/admin/categories/searchpagenated?name=${categoryname}&size=${categoryPage.size}&page=${categoryPage.totalPages}'/>"
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
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
		crossorigin="anonymous"></script>
</body>
</html>