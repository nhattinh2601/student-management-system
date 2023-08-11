package vn.iotstar;




import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import vn.iotstar.config.StorageProperties;
import vn.iotstar.service.IStorageService;

@SpringBootApplication
@EnableConfigurationProperties(StorageProperties.class) 
public class SpringBootVideoApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringBootVideoApplication.class, args);
	}
	// them cau hinh Storage
	@Bean
	CommandLineRunner init(IStorageService storageService) {
		return (arg ->{
			storageService.init();
		});
	}
	@Bean
	public CommonsMultipartResolver multipartResolver() {
		CommonsMultipartResolver resolver = new CommonsMultipartResolver();
		resolver.setDefaultEncoding("UTF-8");
		return resolver;
	}
	
	@Bean
	public Cloudinary cloudinary() {
		Cloudinary c = new Cloudinary(ObjectUtils.asMap(
				"cloud_name", "dxmz6zoea",
				"api_key", "319489613795499",
				"api_secret", "ghUZx7ZxQtTShIBiFxAOvTa4vIY",
				"secure",true
				));
		return c;
	}
}
