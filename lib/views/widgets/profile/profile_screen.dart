import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/profile/profile_controller.dart';
import 'profile_card.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfileScreen extends GetWidget {
	const ProfileScreen({super.key});

	@override
	Widget build(BuildContext context) {
		return GetBuilder(
				init: Get.put(ProfileConntroller(), permanent: false),
				builder: (ctr) {
					return Scaffold(
						appBar: AppBar(
							title: Text('profile'.tr),
							actions: [
								IconButton(
									onPressed: () {
										Get.toNamed('/profile/actions');
									},
									icon: const Icon(Icons.grid_3x3_sharp),
								),
							],
						),
						body: Obx(() => ctr.isLoading.value
								? const Center(
										child: CircularProgressIndicator(),
									)
								: SingleChildScrollView(
										child: Padding(
											padding: const EdgeInsets.all(8.0),
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													profileCard(ctr.user!),
													const SizedBox(height: 10),
													const Divider(),
													const SizedBox(height: 10),
													const Text(
														'Posts',
														style: TextStyle(fontSize: 20),
														textAlign: TextAlign.start,
													),
													const SizedBox(height: 10),
													Obx(() => ctr.isPostsLoading.value
															? const Center(
																	child: CircularProgressIndicator(),
																)
															: (ctr.posts.isEmpty && !ctr.isPostsLoading.value)
																	? const Center(
																			child: Text('No Posts to display'),
																		)
																	: ListView.builder(
																			shrinkWrap: true,
																			physics:
																					const NeverScrollableScrollPhysics(),
																			itemCount: ctr.posts.length,
																			itemBuilder: (context, index) {
																				if (index == ctr.posts.length - 3) {
																					ctr.getMoreUserPosts();
																				}
																				var post = ctr.posts[index];
																				return ListTile(
																					title: Text(post.description!),
																					subtitle: Row(
																						children: [
																							Text(
																								timeago.format(
																									post.createdAt!.toDate(),
																									locale:
																											Get.locale!.languageCode,
																								),
																								style: TextStyle(
																									fontSize: 12,
																									color: Colors.grey[600],
																								),
																							),
																						],
																					),
																					trailing: IconButton(
																						onPressed: () {},
																						icon: const Icon(
																								Icons.delete_outline_rounded),
																					),
																				);
																			},
																		)),
												],
											),
										),
									)),
					);
				});
	}
}
