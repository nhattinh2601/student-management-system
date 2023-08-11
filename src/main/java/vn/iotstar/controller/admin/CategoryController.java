package vn.iotstar.controller.admin;

import java.util.List;
import java.util.Optional;

import java.util.stream.Collectors;
import java.util.stream.IntStream;

import javax.validation.Valid;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;


import vn.iotstar.entity.Category;
import vn.iotstar.model.CategoryModel;
import vn.iotstar.service.ICategoryService;

// neu la api thi la RestController
@Controller
@RequestMapping("admin/categories")
public class CategoryController {
	@Autowired
	ICategoryService categoryService;
	
	@RequestMapping("")
	public String list(ModelMap model) {
		List<Category> list = categoryService.findAll();
		model.addAttribute("categories",list);
		return "admin/categories/list";
	}
	
	@RequestMapping("add")
	public String Add(ModelMap model) {
		CategoryModel cate = new CategoryModel();
		cate.setIsEdit(false);
		model.addAttribute("category", cate);
		return "admin/categories/addOrEdit";		
	}
	
	
	@PostMapping("saveOrUpdate")
	public ModelAndView saveOrUpdate(ModelMap model,
			@Valid @ModelAttribute("category") CategoryModel cate, BindingResult result ) {
		if(result.hasErrors()) {
			return new ModelAndView("admin/categories/addOrEdit");
		}
		Category entity = new Category();
		
		BeanUtils.copyProperties(cate, entity);
		
		categoryService.save(entity);
		
		String message = "";
		if(cate.getIsEdit()==true) {
			message="Category da duoc cap nhat thanh cong";
		}else {
			message="Category da duoc them thanh cong";
		}
		model.addAttribute("message", message);
		return new ModelAndView("forward:/admin/categories",model);
	}
	
	@GetMapping("edit/{categoryId}")
	public ModelAndView edit(ModelMap model,
			@PathVariable("categoryId") Long categoryId ) {
		Optional<Category> opt = categoryService.findById(categoryId);
		
		CategoryModel cate = new CategoryModel();
		if(opt.isPresent()) {
			Category entity = opt.get();
			BeanUtils.copyProperties(entity, cate);  // copy tu entity sang model
			cate.setIsEdit(true);
			model.addAttribute("category", cate);
			return new ModelAndView("admin/categories/addOrEdit",model);
		}
		model.addAttribute("message", "Khong ton tai");
		return new ModelAndView("forward:/admin/categories",model);
	}
	
	
	@GetMapping("delete/{categoryId}")
	public ModelAndView delete(ModelMap model,
			@PathVariable("categoryId") Long categoryId) {
		categoryService.deleteById(categoryId);
		model.addAttribute("message", "Category da duoc xoa thanh cong");
		return new ModelAndView("forward:/admin/categories/searchpagenated",model);
	}
	
	
	@GetMapping("search")
	public String search(ModelMap model, @RequestParam(name="name",required = false) String name ) {
		List<Category> list = null;
		if(StringUtils.hasText(name)) {
			list = categoryService.findByCategorynameContaining(name);
		}else {
			list = categoryService.findAll();
		}
		model.addAttribute("categories", list);
		return "admin/categories/search";
	}
	
	@RequestMapping("searchpagenated")
	public String search(ModelMap model, 
			@RequestParam(name="name",required = false) String name,
			@RequestParam("page") Optional<Integer> page,
			@RequestParam("size") Optional<Integer> size) {
		
		int count = (int) categoryService.count();
		int currentPage = page.orElse(1);
		int pageSize = size.orElse(3);
		
		Pageable pageable = PageRequest.of(currentPage-1,pageSize,Sort.by("categoryId"));
		
		Page<Category> resultPage = null;
		
		if(StringUtils.hasText(name)) {
			resultPage = categoryService.findByCategorynameContaining(name, pageable);
			model.addAttribute("name", name);
		}else {
			resultPage = categoryService.findAll(pageable);
		}
		
		int totalPages = resultPage.getTotalPages();
		if(totalPages > 0) {
			int start = Math.max(1, currentPage-2);
			int end = Math.min(currentPage + 2, totalPages);
			if(totalPages > count) {
				if(end == totalPages) start = end - count;
				else if (start == 1) end = start + count;
			}
			List<Integer> pageNumbers = IntStream.rangeClosed(start, end)
					.boxed()
					.collect(Collectors.toList());
			model.addAttribute("pageNumbers", pageNumbers);
		}
		
		 model.addAttribute("categoryPage", resultPage);
		
		return "admin/categories/searchpagenated";
	}
}
