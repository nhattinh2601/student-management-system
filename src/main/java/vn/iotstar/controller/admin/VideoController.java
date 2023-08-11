package vn.iotstar.controller.admin;


import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import javax.validation.Valid;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.data.domain.*;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import vn.iotstar.entity.Category;
import vn.iotstar.entity.Video;
import vn.iotstar.model.CategoryModel;
import vn.iotstar.model.VideoModel;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IStorageService;
import vn.iotstar.service.IVideoService;


@Controller
@RequestMapping("admin/videos")
public class VideoController {
	@Autowired
	IVideoService videoService;
	@Autowired
	ICategoryService categoryService;
	@Autowired
	IStorageService storageService;
	@Autowired
	Cloudinary cloudinary;
	
	@ModelAttribute("categories")
	public List<CategoryModel> getCategories(){
		return categoryService.findAll().stream().map(item->{
			CategoryModel cate = new CategoryModel();
			BeanUtils.copyProperties(item, cate);
			return cate;
		}).toList();
	}
	
	@GetMapping("/images/{filename:.+}")
	@ResponseBody
	public ResponseEntity<Resource> serverFile(@PathVariable String filename){
		Resource file = storageService.loadAsResource(filename);
		return ResponseEntity.ok().header(HttpHeaders.CONTENT_DISPOSITION,
				"attachment;filename=\""+file.getFilename()+"\"").body(file);
	}
	
	
	@RequestMapping("")
	public String list(ModelMap model) {
		List<Video> list = videoService.findAll();
		model.addAttribute("videos",list);
		return "admin/videos/list";
	}
	
	@RequestMapping("add")
	public String Add(ModelMap model) {
		VideoModel video = new VideoModel();
		video.setIsEdit(false);
		model.addAttribute("video", video);
		return "admin/videos/addOrEdit";		
	}
	
	
	@PostMapping("saveOrUpdate")
	public ModelAndView saveOrUpdate(ModelMap model,
			@Valid @ModelAttribute("video") VideoModel cate, BindingResult result ) {
		if(result.hasErrors()) {
			return new ModelAndView("admin/videos/addOrEdit");
		}
		
		Video entity = new Video();
		
		BeanUtils.copyProperties(cate, entity);
//		
		Category cateEntity = new Category();
		cateEntity.setCategoryId(cate.getCategoryId());
		entity.setCategory(cateEntity);

		//Xu ly anh
		if(!cate.getImageFile().isEmpty()) {
			if(cate.getIsSource()==false) {								
			UUID uuid = UUID.randomUUID();
			String uuString = uuid.toString();
			entity.setPoster(storageService.getStorageFilename(cate.getImageFile(), uuString));
			storageService.store(cate.getImageFile(), entity.getPoster());
			cate.setIsSource(false);
			System.out.println("Da thuc hien duoc luu vao server");
			}else {
				//luu file vao cloudinary
				System.out.println("Da thuc hien duoc luu vao cloudinary");
				try {
					Map r = this.cloudinary.uploader().upload(cate.getImageFile().getBytes(),
							ObjectUtils.asMap("resource_type","auto"));
					String img = (String) r.get("secure_url");
					entity.setPoster(img);
					cate.setIsSource(true);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}
		}
		
		videoService.save(entity);
		System.out.println(cate.getIsEdit());
		String message = "";
		if(cate.getIsEdit()==true) {
			message="Video da duoc cap nhat thanh cong";
		}else {
			message="Video da duoc them thanh cong";
		}
		model.addAttribute("message", message);
		return new ModelAndView("forward:/admin/videos",model);
	}
	
	@GetMapping("edit/{videoId}")
	public ModelAndView edit(ModelMap model,
			@PathVariable("videoId") String videoId ) {
		Optional<Video> opt = videoService.findById(videoId);
		
		VideoModel cate = new VideoModel();
		if(opt.isPresent()) {
			Video entity = opt.get();
			BeanUtils.copyProperties(entity, cate);  // copy tu entity sang model
//			kiem tra xem anh da luu tren server hay cloudinary
			
			if(("https").equals(entity.getPoster().substring(0, 5))) {
				cate.setIsSource(true);
			}else {
				cate.setIsSource(false);
			}
			
			
			cate.setIsEdit(true);
			
			model.addAttribute("video", cate);
			return new ModelAndView("admin/videos/addOrEdit",model);
		}
		model.addAttribute("message", "Khong ton tai");
		return new ModelAndView("forward:/admin/videos",model);
	}
	
	
	@GetMapping("delete/{videoId}")
	public ModelAndView delete(ModelMap model,
			@PathVariable("videoId") String videoId) {
		videoService.deleteById(videoId);
		model.addAttribute("message", "Video da duoc xoa thanh cong");
		return new ModelAndView("forward:/admin/videos/searchpagenated",model);
	}
	
	
	@GetMapping("search")
	public String search(ModelMap model, @RequestParam(name="name",required = false) String name ) {
		List<Video> list = null;
		if(StringUtils.hasText(name)) {
			list = videoService.findByTitleContaining(name);
		}else {
			list = videoService.findAll();
		}
		model.addAttribute("videos", list);
		return "admin/videos/search";
	}
	
	@RequestMapping("searchpagenated")
	public String search(ModelMap model, 
			@RequestParam(name="name",required = false) String name,
			@RequestParam("page") Optional<Integer> page,
			@RequestParam("size") Optional<Integer> size) {
		
		int count = (int) videoService.count();
		int currentPage = page.orElse(1);
		int pageSize = size.orElse(3);
		
		Pageable pageable = PageRequest.of(currentPage-1,pageSize,Sort.by("videoId"));
		
		Page<Video> resultPage = null;
		
		if(StringUtils.hasText(name)) {
			resultPage = videoService.findByTitleContaining(name, pageable);
			model.addAttribute("name", name);
		}else {
			resultPage = videoService.findAll(pageable);
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
		
		 model.addAttribute("videoPage", resultPage);
		
		return "admin/videos/searchpagenated";
	}
}
