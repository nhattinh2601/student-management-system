package vn.iotstar.model;

import javax.validation.constraints.NotEmpty;

import org.hibernate.validator.constraints.Length;
import org.springframework.web.multipart.MultipartFile;

import lombok.AllArgsConstructor;
import lombok.Data;

import lombok.NoArgsConstructor;



@Data
@AllArgsConstructor
@NoArgsConstructor

public class CategoryModel {
	private Long categoryId;
	private String categorycode;
	
	@NotEmpty
	@Length(min = 5)
	private String categoryname;
	private String images;
	private MultipartFile imageFile;
	private boolean status;
	private Boolean isEdit = false;
}
